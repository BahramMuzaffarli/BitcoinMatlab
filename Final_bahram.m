trainData     = 'trainData.csv';
testData      = 'testData.csv';

lastDayBTC_test = report(trainData,testData);
fprintf('Bitcoin Quantity on the Final Day of the Test Dataset: %.2f\n', lastDayBTC_test);
