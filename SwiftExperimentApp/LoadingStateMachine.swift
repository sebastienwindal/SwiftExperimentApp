//
//  LoadingStateMachine.swift
//  SwiftExperimentApp
//
//  Created by Sebastien on 1/13/15.
//
//

import UIKit
import Foundation

enum LoadingStates: Printable {
    case LoadingStateIdle
    case LoadingStateLoading
    case LoadingStateConnected
    case LoadingStateCompletedWithSuccess
    case LoadingStatecompletedWithFailure

    var description : String {
        get {
            switch(self) {
            case LoadingStateIdle:
                return "Idle"
            case LoadingStateLoading:
                return "loading"
            case LoadingStateConnected:
                return "connected"
            case .LoadingStatecompletedWithFailure:
                return "failed"
            case .LoadingStateCompletedWithSuccess:
                return "success"
            }
        }
    }
}


class LoadingStateMachine: NSObject {

    typealias StateChangeCallbackType = (LoadingStates) -> Void

    var callbacks: Array<StateChangeCallbackType> = [];

    var state: LoadingStates = .LoadingStateIdle {
        didSet {
            if state != oldValue {
                for callback in callbacks {
                    callback(state)
                }
            }
        }
    }

    private var data: NSMutableData = NSMutableData()

    private var connection: NSURLConnection!

    override init() {

    }

    func registerForStateChange(stateChangeCallback: StateChangeCallbackType) {
        callbacks.append(stateChangeCallback)
    }

    func startLoadingURL(url urlString: String) {
        var url = NSURL(string: urlString)

        connection = NSURLConnection(request: NSURLRequest(URL: url!), delegate: self, startImmediately: false)
        state = .LoadingStateLoading

        connection.start()
    }

    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()

        var httpResponse = response as NSHTTPURLResponse

        if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            self.state = LoadingStates.LoadingStateConnected
        } else {
            self.state = LoadingStates.LoadingStatecompletedWithFailure
        }
    }

    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        // Append the received chunk of data to our data object
        self.data.appendData(conData)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var err: NSError

        var txt: String = NSString(data: self.data, encoding: NSUTF8StringEncoding)!

        state = LoadingStates.LoadingStateCompletedWithSuccess
    }

}
