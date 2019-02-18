

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Button Action
    @IBAction func tabBarThree(_ sender: Any) {
        let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "TabBArVc") as! TabBArVC
        tabBarControllerVcObj.selectedIndex = 2
        self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
    }
    
    @IBAction func tabBarTwo(_ sender: Any) {
        let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "TabBArVc") as! TabBArVC
        tabBarControllerVcObj.selectedIndex = 1
           Alomafire.sharedInstance.currentStatus = navigatorStatus.Filter
        self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
    }
    @IBAction func tabBarOneAction(_ sender: Any) {
        let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "TabBArVc") as! TabBArVC
        Alomafire.sharedInstance.currentStatus = navigatorStatus.List
         tabBarControllerVcObj.selectedIndex = 0
        self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
    }
}

