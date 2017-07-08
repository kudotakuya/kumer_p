//
//  mapViewController.swift
//  kumar_p
//
//  Created by Takuya Kudo on 2017/07/08.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var myMap: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    var line = MKPolyline() //直線
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 中心点の緯度経度
        let lat: CLLocationDegrees = 35.252982
        let lon: CLLocationDegrees = 139.000761
        coordinate = CLLocationCoordinate2DMake(lat, lon)
        
        // 地図の中心の座標.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        
        
        myMap.center = self.view.center
        myMap.centerCoordinate = center
        myMap.delegate = self
        
        // 縮尺を指定.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
        
        // regionをmapViewに追加.
        myMap.region = myRegion
        
        // viewにmapViewを追加.
        self.view.addSubview(myMap)
        
        // 直線を引く座標を作成.
        
        let coordinate_1 = CLLocationCoordinate2D(latitude: 35.253179, longitude: 139.000123)
        
        let coordinate_2 = CLLocationCoordinate2D(latitude: 35.253074, longitude: 139.000144)
        
        let coordinate_3 = CLLocationCoordinate2D(latitude: 35.253429, longitude: 139.000675)
        
        let coordinate_4 = CLLocationCoordinate2D(latitude: 35.253731, longitude: 139.000375)
        
        
        
        // 座標を配列に格納.
        var coordinates_1 = [coordinate_1, coordinate_2, coordinate_3, coordinate_4]
        
        // polyline作成.
        let myPolyLine_1: MKPolyline = MKPolyline(coordinates: &coordinates_1, count: coordinates_1.count)
        
        // mapViewにcircleを追加.
        myMap.add(myPolyLine_1)
        
        // Do any additional setup after loading the view.
        
        // ピンを生成.
        let childPin: MKPointAnnotation = MKPointAnnotation()
        
        
        // 経度、緯度.
        let childLatitude: CLLocationDegrees = 35.253731
        let childLongitude: CLLocationDegrees = 139.000375
        
        // 中心点.
        let child: CLLocationCoordinate2D = CLLocationCoordinate2DMake(childLatitude, childLongitude)
        
        // 座標を設定.
        childPin.coordinate = child
        
        // MapViewにピンを追加.
        myMap.addAnnotation(childPin)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     addAnnotation後に実行される.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myIdentifier = "myPin"
        
        var myAnnotation: MKAnnotationView!
        
        // annotationが見つからなかったら新しくannotationを生成.
        if myAnnotation == nil {
            myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: myIdentifier)
        }
        
        // 画像を選択.
        myAnnotation.image = UIImage(named: "boy.png")!
        myAnnotation.annotation = annotation
        
        return myAnnotation
    }
    
    /*
     addOverlayした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        // 線の太さを指定.
        myPolyLineRendere.lineWidth = 3
        
        // 線の色を指定.
        myPolyLineRendere.strokeColor = UIColor.red
        
        return myPolyLineRendere
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
