##Loading the libraries
library(shiny)
library(randomForest)

##Reading the train data from csv
trainData <- read.csv("train.csv",comment.char="", quote="\"", sep=",", 
                    header=TRUE, 
                    stringsAsFactors=FALSE,
                    colClasses=c("integer", "integer", "integer","character", "character", 
                                 "numeric", "integer", "integer", "character", 
                                 "numeric", "character", "character"),
                    na.strings = "NA")

## Preoaring variable features for prediction
trainData$Embarked[which(trainData$Embarked == "")] <- 'S'
trainData$Pclass <- as.numeric(trainData$Pclass)
trainData$Sex <- factor(trainData$Sex)
trainData$Embarked <- factor(trainData$Embarked)
trainData$Survived <- factor(trainData$Survived)
trainData$Family<-trainData$SibSp+trainData$Parch
trainData$Family[which(trainData$Family > 0)]<-1
trainData$Family[which(trainData$Family == 0)]<-0
trainData$Family<-factor(trainData$Family)
trainData$Age[which(is.na(trainData$Age))]<-median(trainData$Age[which(!is.na(trainData$Age))])
trainData$Age_Group[which(trainData$Age > 18)]<-"Adult"
trainData$Age_Group[which(trainData$Age <= 18)]<-"Child"
trainData$Age_Group<-factor(trainData$Age_Group)
trainData$Cabin_Cat[which(trainData$Cabin == "")]<-0
trainData$Cabin_Cat[which(trainData$Cabin != "")]<-1
trainData$Cabin_Cat<-factor(trainData$Cabin_Cat)

##Creating a subset of required variables
subtrain<-trainData[,c("PassengerId","Pclass","Embarked", "Cabin_Cat","Age_Group","Sex","Family","Survived")]

##Training the model using Random Forest Algorithm
model<- randomForest(Survived ~ Pclass+Sex+Embarked+Age_Group+Cabin_Cat+Family, data=subtrain, 
                      ntree = 5000, importance = TRUE, na.action=na.omit)

##Creating a dummy record that will be overwritten using inputs entered by user
PassengerId<-893
Pclass<-1
Cabin_Cat<-0
Sex<-'female'
Age_Group<-'Adult'
Embarked<-'Q'
Survived<-1
Family<-0

##Creating the final data frame that will be ised in prediction
test<-data.frame(PassengerId,Pclass,Embarked,Cabin_Cat,Age_Group,Sex,Family,Survived)
final<-rbind(subtrain,test)



shinyServer(function(input,output){
        #creating the predict function.
        #Predicting on entire dataset by appending the user input to a new record
        #in the dataset. Finally returning the predicted value of that dataset
        #The predicted value is in terms of probability which is converted to %
        ##The dummy record is overwritten by user input.
        
        preds <- reactive( {
                
                final[893, 'Pclass'] <- input$pclass
                
                final[893, "Embarked"] <- input$Embarked
                
                final[893, "Cabin_Cat"] <- input$Cabin_Cat
                
                final[893, "Age_Group"] <- input$Age_Group
                
                final[893, "Sex"] <- input$Sex
                
                final[893, "Family"] <- input$Family
                
                val<-predict(model, final, type='prob')
                
                val2<-val[,2]
                
                return(val2[893] * 100)
                
                
                
        })
            
        
                ## Returning the predicted probability with a % sign appended
                output$test2<- renderText({tmp <- preds()
                        return(paste(tmp, '%',sep=''))
                        
                })
                
                ##Returning the decision based on probability calculated.
                ## If probability % > 50 than survived else perished.
                output$test<- renderText({tmp <- preds()
                                           if (tmp >= 50){
                                                   tmp="Survives"
                                           }else{tmp="Does Not Survive"}
                                           return(tmp)
                                           
                })
                
                ##Returning the actual data which meets the selection criteria of the user
                output$table <- renderDataTable({
                        data_displ <- trainData[trainData$Pclass == input$pclass & 
                                        trainData$Embarked == input$Embarked &
                                        trainData$Cabin_Cat == input$Cabin_Cat &
                                        trainData$Age_Group == input$Age_Group &
                                        trainData$Sex == input$Sex &
                                        trainData$Family == input$Family,]
                      
                        data_displ
                })
                
                ## Creating a download widget to download actual dataset used in this app
                output$downloadData <- downloadHandler(
                        filename = function() { 
                                paste('train', '.csv', sep='') 
                        },
                        content = function(file) {
                                write.csv(trainData, file)
                        })

      
}
)