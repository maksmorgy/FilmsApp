import Foundation

protocol FilmManagerDelegate: AnyObject {
    func didUpdateData(film: FilmsModel)
    func didFailWithError(error: Error)
    func setCell() -> FilmsModel?
}
