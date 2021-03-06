//
//  ViewController.swift
//  DateShare
//
//  Created by 伊藤祐哉 on 2021/12/28.
//  Join 木下真菜

import UIKit

class TopViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    private var offsetX: CGFloat = 0
    private var timer: Timer!
    
    
    struct Photo{
        var imageName: String
    }
    
    var photoList = [
        Photo(imageName: "see"),
        Photo(imageName: "BBQ"),
        Photo(imageName: "skii")
    ]
    
    private let photos = ["BBQ", "skii", "see"]
    private let titles = ["BBQ", "skii", "see"]
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        //navigationBar
        self.navigationItem.title = "DateShare"
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        
        //scrollView
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 250))
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width*3, height: self.scrollView.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        
        //pageControl
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 450, width: self.view.frame.size.width, height: 30))
        self.pageControl.numberOfPages = 3
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(self.pageControl)
        
        
        //collectionViewLayout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 6)
        layout.minimumInteritemSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: self.view.frame.width / 10, bottom: 3, right: self.view.frame.width / 10)
        genreCollectionView.collectionViewLayout = layout
        
        //scrollViewにUIImageViewを配置
        self.setUpImageView()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //タイマーを作成
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollPage), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let workingTimer = self.timer {
            workingTimer.invalidate()
        }
    }
    
    
    //ジャンルメニュー
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let photoImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let photoImage = UIImage(named: photos[indexPath.row])
        photoImageView.image = photoImage
        
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(titles[indexPath.row])がタップされました")
    }
    
    
    //写真スライド
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: Photo) -> UIImageView{
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image.imageName)
        imageView.image = image
        return imageView
    }
    
    func setUpImageView(){
        for i in 0 ..< self.photoList.count{
            let photoitem = self.photoList[i]
            let imageView = createImageView(x: 0, y: 0, width: self.view.frame.size.width, height: self.scrollView.frame.size.height, image: photoitem)
            imageView.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width * CGFloat(i), y: 0), size: CGSize(width: self.view.frame.size.width, height: self.scrollView.frame.size.height))
            self.scrollView.addSubview(imageView)
        }
    }
    @objc func scrollPage(){
        self.offsetX += self.view.frame.size.width
        if self.offsetX < self.view.frame.size.width * 3{
            UIView.animate(withDuration: 0.3){
                self.scrollView.contentOffset.x = self.offsetX
            }
        }else {
            UIView.animate(withDuration: 0.3){
                self.offsetX = 0
                self.scrollView.contentOffset.x = self.offsetX
            }
        }
    }
}

extension TopViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        self.offsetX = self.scrollView.contentOffset.x
    }
}

