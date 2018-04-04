//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 15/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties
    var city: City?
    var favorites = [City]()
    var outfitImage: UIImageView?
    var animator: UIDynamicAnimator?
    var clothes: [UIImageView]?
    var isSaved = false
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var saveFavorite: UIBarButtonItem!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var centerAlignStackView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.createAnimatorBehavior()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: ViewController Delegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Move view out of the view
        centerAlignStackView.constant += view.bounds.width
        iconLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.centerAlignStackView.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: { finished in UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.iconLabel.isHidden = false
        }, completion: nil)})
    }
    
    // MARK: Actions
    @IBAction func saveAsFavorite(_ sender: UIBarButtonItem) {
        // TODO: change favorites array to set so to avoid duplicate data
        if !(city?.isFavorite)! {
            sender.image = #imageLiteral(resourceName: "star-filled")
            city?.isFavorite = true
            favorites.append(city!)
            
            if Storage.fileExists() {
             favorites += Storage.load([City].self)
            }
            saveData()
        } else {
            sender.image = #imageLiteral(resourceName: "star")
            city?.isFavorite = false
            let cityIndex = favorites.index(where: { $0.name == city?.name})
            favorites.remove(at:cityIndex!)
            saveData()
            
        }
    }
    
    // MARK: Helper functions
    func saveData() {
        
        if Storage.save(favorites) {
            print("Saving succeeded")
            print(favorites.count)
        } else {
            print("Saving failed")
        }
    }
    func setupViews() -> Void {
        if let city = city {
            cityLable.text = city.name
            let temp = city.temperature
            temperatureLabel.text = "\(temp)℃"
            windLabel.text = "\(city.wind) m/s"
            iconLabel.text = city.icon
            
            if city.isFavorite {
                saveFavorite.image = #imageLiteral(resourceName: "star-filled")
            } else {
                saveFavorite.image = #imageLiteral(resourceName: "star")
            }
        }
    }
    
    func addImage() {
        let imageX = self.view.bounds.width / 2 - 50.0
        outfitImage = UIImageView(frame: CGRect(x: imageX, y: -100, width: 100, height: 100))
        outfitImage?.image = self.getImage()
        clothes = [UIImageView]()
        clothes?.append(outfitImage!)
        self.view.addSubview(outfitImage!)
    }
    
    func createAnimatorBehavior() {
        let boundaryY = self.view.bounds.height - 50.0
        animator = UIDynamicAnimator(referenceView: self.view)
        let gravity = UIGravityBehavior(items: clothes!)
        let collider = UICollisionBehavior()
        animator?.addBehavior(gravity)
        collider.addItem(outfitImage!)
        collider.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: boundaryY), to: CGPoint(x: self.view.bounds.width, y: boundaryY))
        collider.collisionMode = .everything
        animator?.addBehavior(collider)
    }
    
    func getImage() -> UIImage {
        switch city!.description {
        case "Snow":
            return #imageLiteral(resourceName: "beanie")
        case "Rain":
            return #imageLiteral(resourceName: "umbrella")
        case "Clouds":
            return city!.temperature > 15 ? #imageLiteral(resourceName: "t-shirt") : #imageLiteral(resourceName: "jumper")
        case "Clear":
            return city!.temperature > 10 ? #imageLiteral(resourceName: "sunglasses") : #imageLiteral(resourceName: "beanie")
        case "Mist":
            return city!.temperature > 20 ? #imageLiteral(resourceName: "t-shirt") : #imageLiteral(resourceName: "jumper")
        default:
            return #imageLiteral(resourceName: "jumper")
        }
    }
    
}
