//
//  CoreDataService.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 24.09.22.
//

import Foundation
import CoreData


final class CoreDataService {
    
    enum CDSError: Error {
        case failedToSave
        case failedToFetchData
        case failedToDelete
    }
    
    static let shared = CoreDataService()
    private init(){}
    
    func download(for movie: Movie, complition: @escaping (Result<Void, Error>) -> Void) {

        convert(movie: movie)
        
        do {
            try context.save()
            complition(.success(()))
        }
        catch {
            complition(.failure(CDSError.failedToSave))
        }
    }
    
    func fetchData(complition: @escaping (Result<[MovieEntity], Error>) -> Void) {
        do {
            let movieEntities = try context.fetch(MovieEntity.fetchRequest())
            
            complition(.success(movieEntities))
        }
        catch {
            complition(.failure(CDSError.failedToFetchData))
        }
    }
    
    func delete(movieEntity: MovieEntity, complition: @escaping ((Result<Void, Error>) -> Void)) {
        context.delete(movieEntity)
        do {
           try context.save()
            complition(.success(()))
        }
        catch {
            complition(.failure(CDSError.failedToDelete))
        }
    }
    
    //save stuff
    private func convert(movie: Movie) {
        let item = MovieEntity(context: context)
        item.name = movie.name
        item.docDescription = movie.docDescription
        item.moviePosterEntity = convert(posert: movie.poster)
        item.movieRaitingEntity = convert(rating: movie.rating)
        item.alternativeName = movie.alternativeName
        item.movieLength = Int64(movie.movieLength ?? 0)
        item.year = Int64(movie.year)
        item.id = Int64(movie.id)
//        return item
    }
    private func convert(posert: MoviePoster?) -> MoviePosterEntity? {
        guard let posert = posert else { return nil}
        let item = MoviePosterEntity(context: context)
        item.previewURL = posert.previewURL
        item.url = posert.url
        item.id = posert.id
        return item
    }
    
    private func convert(rating: MovieRating?) -> MovieRatingEntity? {
        guard let rating = rating else {return nil}
        let item = MovieRatingEntity(context: context)
        item.id = rating.id
        item.filmCritics = rating.filmCritics ?? 0
        item.imdb = rating.imdb ?? 0
        item.kp = rating.kp ?? 0
        return item
    }
    
    //fetch staff
    func convert(movieEntity: MovieEntity) -> Movie {

        return Movie(poster: convert(posterEntity: movieEntity.moviePosterEntity),
                     rating: convert(ratingEntity: movieEntity.movieRaitingEntity),
                          movieLength: Int(movieEntity.movieLength),
                          id: Int(movieEntity.id),
                          name: movieEntity.name,
                          docDescription: movieEntity.docDescription,
                          year: Int(movieEntity.year),
                          alternativeName: movieEntity.alternativeName)
    }

    private func convert(posterEntity: MoviePosterEntity?) -> MoviePoster? {
        return MoviePoster(id: posterEntity?.id,
                           url: posterEntity?.url,
                           previewURL: posterEntity?.previewURL)
    }

    private func convert(ratingEntity: MovieRatingEntity?) -> MovieRating? {
        return MovieRating(id: ratingEntity?.id,
                           kp: ratingEntity?.kp,
                           imdb: ratingEntity?.imdb,
                           filmCritics: ratingEntity?.filmCritics)
    }

    
                          
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "NetflixClone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
