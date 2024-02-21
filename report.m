function lastDayBTC_test = report(trainData, testData ) 
    trainData = readMyData(trainData);
    testData  = readMyData(testData);
    initialUSD      = 0; 
    initialBitcoin  = 5; 
    [sellUSD_train, sellBitcoin_train] = mymethod(trainData,initialUSD,initialBitcoin);
    [sellUSD_est, sellBitcoin_test] = mymethod(testData,initialUSD,initialBitcoin);
    lastDayBTC_train = VisEtc(sellBitcoin_train,sellUSD_train, trainData,'train');
    lastDayBTC_test = VisEtc(sellBitcoin_test,sellUSD_est, testData,'test');
    

function trueIndices = findTrueIndices(logicalList)
    % Find indices of true elements in the logical list
    trueIndices = find(logicalList);

function lastDayBTC = VisEtc(sellBitcoin,sellUSD, bitcoinData, purposeOfMethod)
    sellBTCIndices    = findTrueIndices(sellBitcoin.Action);
    sellUSDIndices    = findTrueIndices(sellUSD.Action);
    Average_BTC_Price = zeros(1, length(bitcoinData.Close));
    averageClosePrice = mean(bitcoinData.Close);

    if purposeOfMethod == "test"
        for i = 1:(length(bitcoinData.Close))
                Average_BTC_Price(i) = mean(bitcoinData.Close(1:i));
                fprintf('Datet: $%s\n', bitcoinData.Date_2(i));
                fprintf('USD Amount: $%.2f\n', sellUSD.Current_Price(i));
                fprintf('BTC Amount: %.2f\n', sellBitcoin.Current_Price(i));
                disp('***********************************');
        end
    end 
   
    figure;
    plot(bitcoinData.Close, 'b-', 'LineWidth', 1.5);
    hold on;
    scatter(sellBTCIndices, bitcoinData.Close(sellBTCIndices), 100, 'go', 'filled');
    scatter(sellUSDIndices, bitcoinData.Close(sellUSDIndices), 100, 'ro', 'filled');
    plot([1, length(bitcoinData.Close)], [averageClosePrice, averageClosePrice], 'k--', 'LineWidth', 2);
    xlabel('Data Points');
    ylabel('Closing Price');
    legend('Closing Price', 'Buy Signal', 'Sell Signal', 'Average BTC Price');
    grid on;
    
    if sellBitcoin.Current_Price(length(bitcoinData.Close)) == 0
            sellBitcoin.Current_Price(length(bitcoinData.Close)) = sellUSD.Current_Price(length(bitcoinData.Close))/bitcoinData.Close(length(bitcoinData.Close));
    end

    %Save jpg
    if purposeOfMethod == "train"
        saveas(gcf, 'strategy.jpg');
        title('Buy and Sell Signals with Average Bitcoin Price at Train');

    end
    if purposeOfMethod == "test"
        saveas(gcf, 'result_test.jpg');
        title('Buy and Sell Signals with Average Bitcoin Price at Test');
    end
    hold off; 
    
    lastDayBTC = sellBitcoin.Current_Price(length(bitcoinData.Close));

function bitcoinData = readMyData(bitcoinData)
    bitcoinData = readtable(bitcoinData);
    bitcoinData.Open    = str2double(bitcoinData.Open);
    bitcoinData.High    = str2double(bitcoinData.High);
    bitcoinData.Low     = str2double(bitcoinData.Low);
  % bitcoinData.Close   = str2double(bitcoinData.Close);
    bitcoinData.Close =   str2double(strrep(bitcoinData.Close, ',', '.'));
   % bitcoinData.Date = datetime(tarihDizisi, 'yyyy-MM-dd');
    bitcoinData.Date_2  = bitcoinData.Date;
    
    bitcoinData = table2timetable(bitcoinData,'RowTimes',bitcoinData.Date);
    bitcoinData.Date = [];
    bitcoinData = flipud(bitcoinData);


    