%% Class 
classdef Money
    properties
        Action
        Current_Price   % List of last prices
    end
    
    methods
        % Constructor to initialize the properties
        function obj = Money(actionList, lastPrices)
            if nargin > 0
                obj.Action = actionList;
            else
                obj.Action = [];
            end
            
            if nargin > 1
                obj.Current_Price = lastPrices;
            else
                obj.Current_Price = [];
            end
        end
    end
end
