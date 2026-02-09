import {registerUser, checkDocumentExists} from '../services/authUserService.js'
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