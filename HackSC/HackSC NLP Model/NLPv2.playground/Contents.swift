import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/adithyanair/Desktop/Tweets.csv"))

let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

let metaData = MLModelMetadata(author: "Adithya Nair", shortDescription: "NLPv2 for sentiment analysis.", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/adithyanair/Desktop/TextSentimentAnalysisv2.mlmodel"))

try sentimentClassifier.prediction(from: "God damnit.")

