//
//  GeoPointsDb.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 01.02.2022.
//

import Foundation
import RealmSwift

@objcMembers class DbGeoPointCached: Object {
    dynamic var id: String?
    dynamic var latitude: Float?
    dynamic var longitude: Float?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class DbGeoPoint {
    let id: String
    let latitude: Float
    let longitude: Float
    
    init(id: String, latitude: Float, longitude: Float) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
}

class DbDataProvider {
    private var realm: Realm?
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("geo_points.realm")
        realm = try? Realm(configuration: config)        
    }
    
    func getGeoPointAmount() -> Int {
        return realm?.objects(DbGeoPointCached.self).count ?? 0
    }
    
    func getGeoPoints() -> [DbGeoPoint] {
        if let geoPoints = realm?.objects(DbGeoPointCached.self) {
            return geoPoints.compactMap { cachedItem in
                return DbGeoPoint(id: cachedItem.id ?? "",
                                  latitude: cachedItem.latitude ?? 0.0,
                                  longitude: cachedItem.longitude ?? 0.0)
            }
        } else {
            return []
        }
    }
    
    func getGeoPoint(id : String) -> DbGeoPoint? {
        let geoPoints = realm?.object(ofType: DbGeoPointCached.self, forPrimaryKey: id)
        if let geoPoints = geoPoints {
            let ret = DbGeoPoint(id: geoPoints.id ?? "",
                                 latitude: geoPoints.latitude ?? 0.0,
                                 longitude: geoPoints.longitude ?? 0.0)
            return ret
        } else {
            return nil
        }
    }
    
    func addGeoPoint(geoPoint: DbGeoPoint) {
        let cachedGeoPoint = DbGeoPointCached()
        cachedGeoPoint.id = geoPoint.id
        cachedGeoPoint.latitude = geoPoint.latitude
        cachedGeoPoint.longitude = geoPoint.longitude
        
        try? realm?.write {
            realm?.add(cachedGeoPoint)
        }
    }
    
    func updateGeoPoint(geoPoint : DbGeoPoint)
    {
        if isGeoPointExist(id: geoPoint.id) {
            let cachedGeoPoint = DbGeoPointCached()
            cachedGeoPoint.id = geoPoint.id
            cachedGeoPoint.latitude = geoPoint.latitude
            cachedGeoPoint.longitude = geoPoint.longitude
            
            try? realm?.write {
                realm?.add(cachedGeoPoint, update: .modified)
            }
        }
    }
    
    func isGeoPointExist(id: String) -> Bool {
        return realm?.object(ofType: DbGeoPointCached.self, forPrimaryKey: id) != nil
    }
}

class GeoPointsDB {
    private let dbDataProvider : DbDataProvider = DbDataProvider()
    
    static var shared: GeoPointsDB = {
        let instance = GeoPointsDB()
        return instance
    }()

    private init() {}
    
    func getGeoPointAmount() -> Int {
        return dbDataProvider.getGeoPointAmount()
    }
    
    func getGeoPoint(id : String) -> DbGeoPoint? {
        return dbDataProvider.getGeoPoint(id: id)
    }
    
    func addGeoPoint(geoPoint: DbGeoPoint) {
        dbDataProvider.addGeoPoint(geoPoint: geoPoint)
    }
    
    func updateGeoPoint(geoPoint : DbGeoPoint)
    {
        dbDataProvider.updateGeoPoint(geoPoint: geoPoint)
    }
    
    func getGeoPoints() -> [DbGeoPoint] {
        return dbDataProvider.getGeoPoints()
    }
}
