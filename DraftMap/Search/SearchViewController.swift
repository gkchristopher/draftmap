import UIKit
import QuartzCore

class SearchViewController: UIViewController {

    fileprivate var results = [Place]()
    fileprivate var selectedPlace: Place?
    fileprivate lazy var searchApi = SearchApi()
    fileprivate var lastSearchTimestamp = Date(timeIntervalSince1970: 0)

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityView: UIView!
    @IBOutlet var searchImageView: UIImageView!

    fileprivate var shouldShowLoadingIndicators = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = shouldShowLoadingIndicators
            activityView.isHidden = !shouldShowLoadingIndicators
            searchImageView.isHidden = !shouldShowLoadingIndicators
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        activityView.layer.cornerRadius = activityView.bounds.width / 2
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewControler = segue.destination as? DetailViewController {
            destinationViewControler.place = selectedPlace
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        if let placeCell = cell as? PlaceTableViewCell {
            let place = results[indexPath.row]
            placeCell.nameLabel.text = place.name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = results[indexPath.row]
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard lastSearchTimestamp.timeIntervalSinceNow < -1 else { return }
        lastSearchTimestamp = Date()

        dismissKeyboard()
        guard let text = searchBar.text, !text.isEmpty else { return }
        shouldShowLoadingIndicators = true

        searchApi.reverseGeocode(place: text) {[weak self] places, error in
            self?.shouldShowLoadingIndicators = false
            guard let places = places, !places.isEmpty else {
                self?.tableView.isHidden = true
                return
            }
            self?.results.removeAll()
            self?.results.append(contentsOf: places)
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        searchBar.text = nil
    }

    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
