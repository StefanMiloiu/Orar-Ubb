///
/// Extension of SettingEntity conforming to Model protocol.
///
extension SettingEntity: Model{
    func toString() -> String {
        return "Link \(section ?? "NIL SECTION") \n Group \(group ?? "NIL GROUP") \n Subgroup \(semiGroup ?? "NIL SUBGROUP") \n )"
    }
}

///
/// Extension of Lecture conforming to Model protocol.
///
extension Lecture: Model{
}
