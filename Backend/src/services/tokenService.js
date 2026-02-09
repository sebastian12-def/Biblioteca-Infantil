import jwt from 'jsonwebtoken';


const JWT_SECRET = process.env.JWT_SECRET;//este el token de el .env




// recibe datos no  sencibles del usuario
export const generateToken = (userId, documento, tipo_usuario) => {

    const payload = {
        id: userId,
        documento:documento ,
        tipo_usuario: tipo_usuario
    }

    try {

        const token = jwt.sign(payload, JWT_SECRET, {//estos 2 => payload y el secret crean la firma y la contactenacion de la paylaod + firma => token
            expiresIn: '7d',
            algorithm: 'HS256'
        });

        return {
            success: true,
            token: token,
            expiresIn: '7d'
        }

    } catch (error) {
        return {
            success: false,
            error: error.message
        }

    }


}



export const verifyToken = (token) => {
    try{
        // jwt.verify() hace:
        // 1. Extrae payload
        // 2. Regenera firma
        // 3. Compara
        // 4. Verifica exp

        const decoded = jwt.verify(token, JWT_SECRET);//si coincide me retorna decode con los datos sino me da un error
        
        return {
            success : true,
            data : decoded
        }

    }catch(error){
        return{
            success : false,
            error : error.message
        }
    }
}
