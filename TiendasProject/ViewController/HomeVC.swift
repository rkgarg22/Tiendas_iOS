
import UIKit

class HomeVC: UIViewController
{
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        let vc = storyboard!.instantiateViewController(withIdentifier: "StoreListVC");
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        addChildViewController(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParentViewController: self)
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
    }
}
extension HomeVC : UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if (viewController is ListInMapViewVC)
        {
    let vc = storyboard!.instantiateViewController(withIdentifier: "StoreListVC")
    return vc
        }
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController is StoreListVC)
        {
            let vc = storyboard!.instantiateViewController(withIdentifier: "ListInMapViewVC")
            return vc
        }
        return nil;
    }
}

    
    

