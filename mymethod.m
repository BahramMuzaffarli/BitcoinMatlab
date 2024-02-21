%function [sellUSD, sellBitcoin] = customizedTradingStrategy(bitcoinData, initialCapital, initialBitcoins)

function [sellUSD, sellBitcoin] = myCustomMethod(bitcoinData, initialCapital, initialBitcoins)
% Exponential Moving Average (EMA): The first step is to calculate the
% exponential moving average of Bitcoin's closing prices over a specific
% window (e.g., 15 days). This represents the average performance of
% prices over a certain period and can be used to smooth out price trends.

    emaWindowSize = 15; % EMA window size
    numStdDevs = 1;  % for upper and lower bands
    % Calculate exponential moving average and standard deviation
    ema = movmean(bitcoinData.Close, emaWindowSize);
    stdDev = movstd(bitcoinData.Close, emaWindowSize);
    % Calculate upper and lower bands
    upperBand = ema + numStdDevs * stdDev;
    lowerBand = ema - numStdDevs * stdDev;
    %  lower band
    buySignalIdx = bitcoinData.Close < lowerBand;
    %  upper band
    sellSignalIdx = bitcoinData.Close > upperBand;
    bitcoinData.BuySignal = false(size(bitcoinData, 1), 1);
    bitcoinData.SellSignal = false(size(bitcoinData, 1), 1);
    % Mark buy signals
    bitcoinData.BuySignal(buySignalIdx) = true;
    % Mark sell signals
    bitcoinData.SellSignal(sellSignalIdx) = true;

    currentCapital = initialCapital;
    currentBitcoins = initialBitcoins;

    capitalAmountList = [];
    bitcoinAmountList = [];
    capitalActionList = [];
    bitcoinActionList = [];
   
    for i = 1:(length(bitcoinData.Close))
        currentCapitalAction = false;
        currentBitcoinAction = false;

       %Before Modification
        % Check if it's a buy signal 
        if bitcoinData.BuySignal(i) && currentCapital ~= 0
            % Buy Bitcoin with available capital
            currentBitcoins = currentBitcoins + currentCapital / bitcoinData.Close(i);
            currentCapital = 0; % No capital left after buying Bitcoin
            currentBitcoinAction = true; 
        end
        % Check if it's a sell signal
        if bitcoinData.SellSignal(i) && currentBitcoins ~= 0
            % Sell Bitcoin for capital
            currentCapital = currentCapital + currentBitcoins * bitcoinData.Close(i);
            currentBitcoins = 0; % No Bitcoin left after selling
            currentCapitalAction = true; 
        end

      % %After Modification
      % % Last Modification: Alternate between selling entire USD and entire Bitcoin
      % if mod(i, 2) == 1
      %     % Sell entire USD on odd days
      %     if currentCapital ~= 0
      %         currentBitcoinAction = true;
      %         currentBitcoins = currentBitcoins + currentCapital / bitcoinData.Close(i);
      %         currentCapital = 0;
      %     end
      % else
      %     % Sell entire Bitcoin on even days
      %     if currentBitcoins ~= 0
      %         currentCapital = currentCapital + currentBitcoins * bitcoinData.Close(i);
      %         currentBitcoins = 0;
      %         currentCapitalAction = true;
      %     end
      % end

        % ELSE No Action!! 
        capitalAmountList(end+1) = currentCapital;
        bitcoinAmountList(end+1) = currentBitcoins;
        capitalActionList(end+1) = currentCapitalAction;
        bitcoinActionList(end+1) = currentBitcoinAction;
    end
    % Create instances of the Money class
    sellUSD     = Money(capitalActionList, capitalAmountList);
    sellBitcoin = Money(bitcoinActionList, bitcoinAmountList);
end

