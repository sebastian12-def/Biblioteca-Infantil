import {registerUser, checkDocumentExists, getUserByDocumento} from '../services/authUserService.js'
// imorto la fn para crear un token
import { generateToken } from '../services/tokenService.js';
import bcrypt from 'bcrypt';


export const registerController = async (req , res)=>{
    const { documento, password , nombre, apellido , tipo_usuario} = req.body

    if (!documento || !password || !nombre || !apellido || !tipo_usuario) {
        return res.status(400).json({// bad request (error del ususaio al enviar los datos ,luego usar ZOD para evitarlo)
            success: false,
            message: "Falta datos requeridos"
        })
    }

    // llamo a service para asi con eso saber si el documento es o no unique
    const documentoExists = await checkDocumentExists(documento);

    if(documentoExists){//si es true pues si existe
        return res.status(409).json({
            success:false,
            message: "Documento ya esta registrado"
        });
    }


    // encripto la password
    const passwordHash = await  bcrypt.hash(password, 10)

    const userData = {
    documento,
    nombre,
    apellido,
    tipo_usuario,
    password: passwordHash  
    }

    const resultado = await registerUser(userData);

    if(!resultado.success){
        return res.status(500).json(resultado)
    }


    // exito
    const usuarioCreado = resultado.data;


    const tokenResult = await generateToken(
        usuarioCreado.id_usuario,
        usuarioCreado.documento,
        usuarioCreado.tipo_usuario
    )

    if(!tokenResult.success){
        return res.status(500).json(tokenResult)//tokeResult tiene un respuesta configurada si falla 
    }


    res.status(201).json({
        success: true,
        message: "Usuario registrado exitosamente",
        token: tokenResult.token,
        expiresIn: tokenResult.expiresIn,

        usuario: {
            id: usuarioCreado.id_usuario,
            documento: usuarioCreado.documento,

            nombre:usuarioCreado.nombre,
            apellido:usuarioCreado.apellido,
            tipo_usuario: usuarioCreado.tipo_usuario
        }
    })


}



export const loginController = async (req, res ) => {

    const {documento , password} = req.body;

    if(!documento || !password ){
        return  res.status(400).json({ //bad request 
            success: false,
            message: "Documento y password son requeridos"
        });
    }


    const usuarioResult =  await getUserByDocumento(documento)

    // "Si success es FALSE" = "Si la query falló" = "Si no encontró usuario"
    if(!usuarioResult.success){//si el usaurio result en su propiedad succes no es true pues no lo encontro
        return res.status(404).json({
            success: false,
            message : "Usuario no encontrado"
        });
    }


    const usuario = usuarioResult.data //esto para que sea mas limpia y calra la comparacion

    // comparar la password cliente vs la hash de la db
    // retorna tru o false
    const esValida = await bcrypt.compare(password, usuario.password)


    if(!esValida){
        return res.status(401).json({
            success: false,
            message: "Password incorrecta"
        })
    }


    // genero el JWT si las password coinciden
    const tokenResult = await generateToken(
        usuario.id_usuario,
        usuario.documento,
        usuario.tipo_usuario
    )


    if(!tokenResult.success){
        return res.status(500).json(tokenResult);
    }

    return res.status(200).json({
        success:true,
        message: "Login exitoso",
        token: tokenResult.token,
        expiresIn: tokenResult.expiresIn,
        
        usuario: {
        id: usuario.id_usuario,
        documento: usuario.documento,
        nombre: usuario.nombre,
        apellido: usuario.apellido,
        tipo_usuario: usuario.tipo_usuario
        }
    })
}