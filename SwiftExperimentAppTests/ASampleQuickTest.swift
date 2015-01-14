//
//  ASampleQuickTest.swift
//  SwiftExperimentApp
//
//  Created by Sebastien on 1/13/15.
//
//

import UIKit
import Quick
import Nimble

class ASampleQuickTest: QuickSpec {

    override func spec() {
        var loader: LoadingStateMachine!

        beforeEach {
            loader = LoadingStateMachine()
        }
        
        describe("registerForStateChange") {
            beforeEach {
            }

            it ("adds the callback to its queue") {
                loader.registerForStateChange({ (state: LoadingStates) -> Void in  });
                expect(loader.callbacks.count).to(equal(1))
            }
        }

        describe("state setting") {
            it ("calls callback") {
                var wasCalled = false
                loader.registerForStateChange({ (state: LoadingStates) -> Void in
                    wasCalled = true
                });

                loader.state = LoadingStates.LoadingStatecompletedWithFailure

                expect(wasCalled).to(beTrue());
            }

            it ("calls multiple callbacks") {
                var count: UInt8 = 0
                loader.registerForStateChange({ (state: LoadingStates) -> Void in
                    count = count + 3
                })
                loader.registerForStateChange({ (state: LoadingStates) -> Void in
                    count = count + 20
                });
                loader.registerForStateChange({ (state: LoadingStates) -> Void in
                    count = count + 100
                });

                loader.state = LoadingStates.LoadingStatecompletedWithFailure

                expect(count).to(equal(12300));
            }

            it ("does not call callback when setting identical state", {
                var count: UInt8 = 0
                loader.registerForStateChange({ (state: LoadingStates) -> Void in
                    count = count + 1
                })

                loader.state = LoadingStates.LoadingStateCompletedWithSuccess
                loader.state = LoadingStates.LoadingStateCompletedWithSuccess
                loader.state = LoadingStates.LoadingStateCompletedWithSuccess
                loader.state = LoadingStates.LoadingStateCompletedWithSuccess
                loader.state = LoadingStates.LoadingStateCompletedWithSuccess
                loader.state = LoadingStates.LoadingStateCompletedWithSuccess

                expect(count).to(equal(1));
            })
        }


    }
}