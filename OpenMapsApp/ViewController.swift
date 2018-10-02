import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// PLIST:
    // LSApplicationQueriesSchemes - Array
        // Item0 - String - waze
        // Item1 - String - comgooglemaps

    let coordinate = CLLocationCoordinate2D(latitude: 35.203891, longitude: -97.441351)   // OU
    var mapApps = [MapApp]()

    @IBAction func openMapsTapped(_ sender: UIButton) {
        openMaps()
    }

    @objc func dismissAlertController() {
        self.dismiss(animated: true, completion: nil)
    }

    func openMaps() {
        // Apple Maps
        let appleUrl = "http://maps.apple.com/maps?daddr=\(coordinate.latitude),\(coordinate.longitude)"
        let apple = MapApp(name: "Apple Maps", url: appleUrl)
        if !mapApps.contains(apple) {
            mapApps.append(apple)
        }

        // Google Maps
        if let canOpenGoogleUrl = URL(string:"comgooglemaps://") {
            if UIApplication.shared.canOpenURL(canOpenGoogleUrl) {
                let googleUrl = "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"
                let google = MapApp(name: "Google Maps", url: googleUrl)
                if !mapApps.contains(google) {
                    mapApps.append(google)
                }
            }
        }

        // Waze
        if let canOpenWazeUrl = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(canOpenWazeUrl) {
                let wazeUrl: String = "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes"
                let waze = MapApp(name: "Waze", url: wazeUrl)
                if !mapApps.contains(waze) {
                    mapApps.append(waze)
                }
            }
        }

        let alert = UIAlertController(title: "Get Directions", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .blue
        let attributedString = NSAttributedString(string: "Get Directions", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        for app in mapApps {
            let button = UIAlertAction(title: app.name, style: .default) { (action) in
                print("App Name = \(app.name)")
                UIApplication.shared.open(URL(string: app.url)!, options: [:], completionHandler: nil)
            }
            alert.addAction(button)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

}

struct MapApp {
    let name: String
    let url: String
}

extension MapApp: Equatable {
    static func ==(lhs: MapApp, rhs: MapApp) -> Bool {
        return lhs.name == rhs.name
    }
}
