
import UIKit

class TabBArVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        // Do any additional setup after loading the view.
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        applicationDelegate.selectedTab = item.tag
        if (applicationDelegate.selectedTab == 0)
        {
             Alomafire.sharedInstance.currentStatus = navigatorStatus.List
        }
        else if (applicationDelegate.selectedTab == 1)
        {
             Alomafire.sharedInstance.currentStatus = navigatorStatus.Filter
        }
        else
        {
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

