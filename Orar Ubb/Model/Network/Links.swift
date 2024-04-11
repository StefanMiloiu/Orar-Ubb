//
//  Links.swift
//  Orar Ubb
//
//  Created by Stefan Miloiu on 06.04.2024.
//

import Foundation

struct Links {
    
    //2023-2024 Sem 2
    static let mainUrl: String = "https://www.cs.ubbcluj.ro/files/orar/2023-2/tabelar/"
    
    static let M: String = "Matematica - linia de studiu romana"
    static let M1: String = "\(mainUrl)M1.html"
    static let M2: String = "\(mainUrl)M2.html"
    static let M3: String = "\(mainUrl)M3.html"
    
    static let I: String = "Informatica - linia de studiu romana"
    static let I1: String = "\(mainUrl)I1.html"
    static let I2: String = "\(mainUrl)I2.html"
    static let I3: String = "\(mainUrl)I3.html"
    
    static let MI: String = "Matematica informatica - linia de studiu romana"
    static let MI1 : String = "\(mainUrl)MI1.html"
    static let MI2 : String = "\(mainUrl)MI2.html"
    static let MI3 : String = "\(mainUrl)MI3.html"
    
    static let MIE: String = "Matematica informatica - linia de studiu engleza"
    static let MIE1 : String = "\(mainUrl)MIE1.html"
    static let MIE2 : String = "\(mainUrl)MIE2.html"
    static let MIE3 : String = "\(mainUrl)MIE3.html"
    
    static let MM: String = "Matematica - linia de studiu maghiara"
    static let MM1 : String = "\(mainUrl)MM1.html"
    static let MM2 : String = "\(mainUrl)MM2.html"
    static let MM3 : String = "\(mainUrl)MM3.html"
    
    static let IM: String = "Informatica - linia de studiu maghiara"
    static let IM1 : String = "\(mainUrl)IM1.html"
    static let IM2 : String = "\(mainUrl)IM2.html"
    static let IM3 : String = "\(mainUrl)IM3.html"
    
    static let MIM: String = "Matematica informatica - linia de studiu maghiara"
    static let MIM1 : String = "\(mainUrl)MIM1.html"
    static let MIM2 : String = "\(mainUrl)MIM2.html"
    static let MIM3 : String = "\(mainUrl)MIM3.html"
    
    static let IIM: String = "Ingineria informatiei - linia de studiu maghiara"
    static let IIM1 : String = "\(mainUrl)IIM1.html"
    
    static let IIA: String = "Informatica - linia de studiu germana"
    static let IG1 : String = "\(mainUrl)IG1.html"
    static let IG2 : String = "\(mainUrl)IG2.html"
    static let IG3 : String = "\(mainUrl)IG3.html"
    
    static let IE: String = "Informatica - linia de studiu engleza"
    static let IE1 : String = "\(mainUrl)IE1.html"
    static let IE2 : String = "\(mainUrl)IE2.html"
    static let IE3 : String = "\(mainUrl)IE3.html"
    
    static let IA: String = "Inteligenta artificiala - linia de studiu engleza"
    static let IA1 : String = "\(mainUrl)IA1.html"
    
    static let II: String = "Ingineria informatiei - linia de studiu engleza"
    static let II1 : String = "\(mainUrl)II1.html"
    
    static let Pshiologie: String = "Psihologie"
    static let Pshio : String = "\(mainUrl)Pshio1.html"
    
    static let names: [String] = [M, I, MI, MIE, MM, IM, MIM, IIM, IIA, IE, IA, II, Pshiologie]
    static let links: [[String]] = [[M1, M2, M3], [I1, I2, I3], [MI1, MI2, MI3], [MIE1, MIE2, MIE3], [MM1, MM2, MM3], [IM1, IM2, IM3], [MIM1, MIM2, MIM3], [IIM1], [IG1, IG2, IG3], [IE1, IE2, IE3], [IA1], [II1], [Pshio]]
    
    static func getNameFromLink(link: String) -> String {
        let parsedLink = link.split(separator: "/")
        let lastPart = parsedLink.last
        let name = lastPart?.split(separator: ".")
        return String(name![0])
    }
}
