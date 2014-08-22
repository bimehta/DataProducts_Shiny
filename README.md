DataProducts_Shiny
==================

This app predicts the survival of an individual based on the characteristics selected by user from the left side pane.
The characteristics of a passenger that the user can select are:

1. Gender of the person using Input Button.
2. The class in which the person was travelling - 1st,2nd or 3rd. 
3. Travelling with family- Input Button- Yes means the person was travelling with at least one fellow traveller who was either his/her parent, child, sibling or spouse.
4. Travelling in Cabin - Input Button - This means the person was travelling in a cabin. Usually passengers in 1st class travel in cabins.
5. The location from where the person started his/her journey. The Tiatanic stopped at 3 places - Queenstown, Cherbourg and Southampton. This is a selection box.
6. Age Group of the passenger using Selection Box. Whether the person travelling was an Adult (>=18) or a Child(<18)

Based on the above values you select for a passenger you will see on right hand side the probability of that person surviving. This probability is calculated using Machine Learning algorithm. In case the survival probability is above 50% the app makes a decision that the person survives.

Below that it also shows the actual passenger data meeting the criteria selected by the user from the train data.

PS: If the criteria selected by user does not match any record in train data, the app calculates Survival probability but in the table just shows 'Processing' as there are no records to show. This is a bug in shiny and I could not find any solution for it. For eg if you select Child in PClass 3 with Cabin yes, you will see probability calculated but there is no actual record that meets such a criteria hence just processing appears on the table. You can change the input selection and you will start seeing records as and when they match the actual data.

Finally is the user is interested, he/she can download the actual train data used to build the machine learning algorithm to test his/her own algorithm.

Hope you enjoy the predictions.

Many thanks for trying this app!
