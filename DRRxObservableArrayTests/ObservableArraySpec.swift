import Quick
import Nimble
import RxSwift
import RxTest

class ObservableArraySpec: QuickSpec {

    override func spec() {
        describe("ObservableArray of Strings") {
            var sut: ObservableArray<String>!

            context("when initialized with array") {
                beforeEach {
                    sut = ObservableArray(["a", "b", "c"])
                }

                afterEach {
                    sut = nil
                }

                it("should have correct elements") {
                    expect(sut.elements).to(equal(["a", "b", "c"]))
                }

                it("should have correct count") {
                    expect(sut.count).to(equal(3))
                }

                context("when element appended") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut.append("d")
                    }

                    afterEach {
                        observer = nil
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "b", "c", "d"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(4))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.inserted(indices: [3], elements: ["d"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when element prepended") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut.prepend("d")
                    }

                    afterEach {
                        observer = nil
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["d", "a", "b", "c"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(4))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.inserted(indices: [0], elements: ["d"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when elements appended") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut.append(contentsOf: ["d", "e"])
                    }

                    afterEach {
                        observer = nil
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "b", "c", "d", "e"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(5))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.inserted(indices: [3, 4], elements: ["d", "e"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when element inserted at index") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut.insert("d", at: 1)
                    }

                    afterEach {
                        observer = nil
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "d", "b", "c"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(4))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.inserted(indices: [1], elements: ["d"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when first element removed") {
                    var removedElement: String!
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        removedElement = sut.removeFirst()
                    }

                    afterEach {
                        removedElement = nil
                        observer = nil
                    }

                    it("should remove correct element") {
                        expect(removedElement).to(equal("a"))
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["b", "c"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(2))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.deleted(indices: [0], elements: ["a"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when last element removed") {
                    var removedElement: String!
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        removedElement = sut.removeLast()
                    }

                    afterEach {
                        removedElement = nil
                        observer = nil
                    }

                    it("should remove correct element") {
                        expect(removedElement).to(equal("c"))
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "b"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(2))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.deleted(indices: [2], elements: ["c"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when element removed at index") {
                    var removedElement: String!
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        removedElement = sut.remove(at: 1)
                    }

                    afterEach {
                        removedElement = nil
                        observer = nil
                    }

                    it("should remove correct element") {
                        expect(removedElement).to(equal("b"))
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "c"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(2))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.deleted(indices: [1], elements: ["b"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when all elements removed") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut.removeAll()
                    }

                    afterEach {
                        observer = nil
                    }

                    it("should have no elements") {
                        expect(sut.elements).to(equal([]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(0))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.deleted(indices: [0, 1, 2], elements: ["a", "b", "c"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }

                context("when get-subscripted") {
                    var element: String!

                    beforeEach {
                        element = sut[1]
                    }

                    it("should return correct element") {
                        expect(element).to(equal("b"))
                    }
                }

                context("when element replaced using subscript") {
                    var observer: TestableObserver<ObservableArrayChangeEvent<String>>!

                    beforeEach {
                        observer = self.createObserver(forSut: sut)
                        sut[1] = "d"
                    }

                    it("should have correct elements") {
                        expect(sut.elements).to(equal(["a", "d", "c"]))
                    }

                    it("should have correct count") {
                        expect(sut.count).to(equal(3))
                    }

                    it("should notify observers") {
                        let expected = [
                            next(0, ObservableArrayChangeEvent<String>.updated(indices: [1], oldElements: ["b"], newElements: ["d"]))
                        ]
                        expect(observer.events).to(equal(expected))
                    }
                }
            }
        }
    }

    private func createObserver(forSut sut: ObservableArray<String>) -> TestableObserver<ObservableArrayChangeEvent<String>> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ObservableArrayChangeEvent<String>.self)
        let _ = sut.events.subscribe(observer)
        scheduler.start()
        return observer
    }

}
