//
//  Valida_Campos.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//
import Foundation

extension String{
    var esVacio:Bool{  // comprobar si esta vacio o no (T or f)
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty   // seld == this   //trimmingCharacters = quitar caracteres al inicio y al final
    }
    
    var esNombreValido:Bool{
        return !self.esVacio && self.count >= 2
    }
    
    var esContrasenavalida:Bool{
        return self.count >= 8   // contrasena de minimo tamano 10
    }
    
    var esCorreoValido:Bool{
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"  // +   significa que debe de tener uno o mas    {2,} al menos dos
        return self.range(of: regex, options: .regularExpression, //expresion regular
                          range: nil, locale: nil) != nil  // range --> para generar tokens (descompone los tring en clases)
    }
}
