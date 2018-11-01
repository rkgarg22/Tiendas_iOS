
import UIKit

class BannerDetailVC: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var bannerWebView: UIWebView!
    var link : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerWebView.delegate = self
        let url = NSURL (string: link!);
        let request =  NSURLRequest(url: url as! URL)
        bannerWebView.loadRequest(request as URLRequest);
    }
    
    @IBAction func backAction(_ sender: Any)
    {
     self.navigationController?.popViewController(animated: true);
    }
    func webViewDidStartLoad(_ : UIWebView) {
       applicationDelegate.showActivityIndicatorView()
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        applicationDelegate.hideActivityIndicatorView()
    }
}
