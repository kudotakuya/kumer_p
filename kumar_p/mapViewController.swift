//
//  mapViewController.swift
//  kumar_p
//
//  Created by Takuya Kudo on 2017/07/08.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import UIKit
import MapKit
import APIKit

class mapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var myMap: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    var myPolyLine_1: MKPolyline!
    var line = MKPolyline() //直線
    var Json: NSArray!
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
        
        let request = GPSDataRequest()
        Session.send(request) { result in
            switch result {
                
            case .success(let responses):
                print(responses)
                //let list = responses as [Any]
                var latlonlist: [CLLocationCoordinate2D]! = []
                for i in 0..<responses.count {
                    print(responses[i].lat)
                    
                //print(list[i])
                
                    latlonlist.append(CLLocationCoordinate2DMake(responses[i].lat as! Double, responses[i].lon as! Double))
                    self.myMap.add(MKPolyline(coordinates: latlonlist, count: latlonlist.count))
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }

//        //getJson(complete:{pline in
//            self.myMap.add(pline)
//        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson(complete: @escaping(MKPolyline!)->Void!) {
        
        let urlStr = "https://version1.xyz/spajam2017/gps.json"
        
        if let url = URL(string: urlStr) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: { (data, resp, err) in
               // print(resp!.url!)
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                var coodList = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any
                
                
                // 受け取ったdataをJSONパース、エラーならcatchへジャンプ
                do {
                    // dataをJSONパースし、グローバル変数"getJson"に格納
                    self.Json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    var lineCoordinate: [CLLocationCoordinate2D]! = []
                    for i in 0..<self.Json.count {
                        
                        let list = self.Json[i] as! [Any]
                        print(list[0] as! Double)
                        lineCoordinate.append(CLLocationCoordinate2DMake(list[0] as! Double, list[1] as! Double))
                        
                    }
                    
                    //print(self.Json[0])
                    
                    // polyline作成.
                    complete(MKPolyline(coordinates: lineCoordinate, count: lineCoordinate.count))
                    //self.myMap.add(self.myPolyLine_1)
                    
                    
                    
                } catch {
                    print ("json error")
                    return
                }
                
                
            })
            task.resume()
            
            
        }
        
        // mapViewにcircleを追加.
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
