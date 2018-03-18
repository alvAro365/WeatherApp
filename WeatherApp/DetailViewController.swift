//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 15/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITabBarControllerDelegate {
    // MARK: Properties
    var city: City?
    var favorites = [City]()
    var imageView: UIImageView?
    var sunglassesImage: UIImageView?
    var animator: UIDynamicAnimator?
//    let gravity = UIGravityBehavior()
    var clothes: [UIImageView]?
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var saveFavorite: UIBarButtonItem!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var centerAlignStackView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        setupViews()
        addImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.createAnimatorBehavior()
        })
//        createAnimatorBehavior()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        let mainViewController = segue.destination as? WeatherAppViewController
//        mainViewController?.city = city!
//    }
    // MARK: ViewController Delegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Move view out of the view
        centerAlignStackView.constant += view.bounds.width
        iconLabel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.centerAlignStackView.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            self.iconLabel.isHidden = false
            }, completion: nil)
        
        
    }
    // MARK: Actions
    @IBAction func saveAsFavorite(_ sender: UIBarButtonItem) {
        
        sender.image = #imageLiteral(resourceName: "star-filled")
        favorites.append(city!)
        // TODO: check if saved file exists before merging arrays
        if Storage.fileExists() {
         favorites += Storage.load([City].self)
        } 
        
        if Storage.save(favorites) {
            print("Saving succeeded")
            print(favorites.count)
        } else {
            print("Saving failed")
        }
    }
    
    // MARK: Private functions
    func setupViews() -> Void {
        
        if let city = city {
//            navigationItem.title = city.name
            cityLable.text = city.name
            let temp = Int(city.temperature)
            temperatureLabel.text = "\(temp)℃"
            windLabel.text = "\(city.wind) m/s"
            iconLabel.text = city.icon
        }
    }
    
    func addImage() {
        // TODO: fix hardcoding values
        let imageX = self.view.bounds.width / 2 - 50.0
//        imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 50, height: 50))
        sunglassesImage = UIImageView(frame: CGRect(x: imageX, y: -100, width: 100, height: 100))
//        imageView?.image = UIImage(named: "jeans")
        sunglassesImage?.image = UIImage(named: "sunglasses")
        clothes = [UIImageView]()
//        clothes?.append(imageView!)
        clothes?.append(sunglassesImage!)
//        self.view.addSubview(imageView!)
        self.view.addSubview(sunglassesImage!)
    }
    
    func createAnimatorBehavior() {
        animator = UIDynamicAnimator(referenceView: self.view)
        let gravity = UIGravityBehavior(items: clothes!)
        let collider = UICollisionBehavior()
        animator?.addBehavior(gravity)
//        collider.addItem(imageView!)
        collider.addItem(sunglassesImage!)
//        let border = self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height)!
        collider.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: 550.0), to: CGPoint(x: self.view.bounds.width, y: 550))
//        collider.translatesReferenceBoundsIntoBoundary = true

//        let collision = UICollisionBehavior(items: clothes!)
        collider.collisionMode = .everything
        animator?.addBehavior(collider)
    }
    
}
