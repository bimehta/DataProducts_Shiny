shinyUI(fluidPage(
        #create title panel
        titlePanel("Titanic Survivor Probability Prediction"),
        h4('This webapp enables the user to predict the survival probability of passengers travelling on Titanic'),
        h4('The prediction is based on Travel Class, Gender, Age Group, Family and Embarked variables'),
        h4('Based on the probability of survival calculated by Prediction Algorithm the app decides whether person will survive or not'),
        helpText(HTML("<a href = \"https://github.com/bimehta/DataProducts_Shiny/blob/master/README.md\">Detailed Documentation</a>")),
        # populate side bar layout
        
        sidebarLayout(
                #creating input widgets
                
                sidebarPanel(
                        
                       
                        radioButtons("Sex","Select the Passenger Gender",
                                     c("Male"="male","Female"="female"),selected="male"),
                        radioButtons("pclass","Select the Passenger Travel Class",
                                     c("1"="1","2"="2", "3"="3"),selected="1"),
                        radioButtons("Family","Travelling with family",
                                     c("Yes"="1","No"="0"),selected="1"),
                        helpText("Note:: If Sibsp and Parch are > 1 in actual dataset means travelling with Family"),
                        radioButtons("Cabin_Cat","Travelling in a Cabin",
                                     c("Yes"="1","No"="0"),selected="1"),
                        selectInput("Embarked","Select the location from where the passenger embarked",c("Queenstown"="Q","Cherbourg"="C", "Southampton"="S"),
                                    selected="Q"),
                        
                        selectInput("Age_Group","Select the age group of passengers",c("Child"="Child","Adult"="Adult"),
                                    selected="Adult"),
                        helpText("Note:: Age below 18 is conisdered child."),
                        submitButton('Predict')
                        
                        
                ),
                #main panel to display output
                mainPanel(
                        h3("Results of Prediction"),
                        h4("Based on the data enetered the probability of person surviving is:"),
                        verbatimTextOutput("test2"),
                        h4("Based on  the probability of person surviving our decision is that the person:"),
                        verbatimTextOutput("test"),
                        h4("Actual List and status of people based on criteria selected"),
                        dataTableOutput(outputId="table"),
                        downloadButton('downloadData', 'Download complete Train Data')
                 
                        )
        
)
)
)