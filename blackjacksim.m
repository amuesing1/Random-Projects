function S = blackjacksim(n,deck_num,S)
%BLACKJACKSIM  Simulate blackjack.
% S = blackjacksim(n)
% Play n hands of blackjack.
% Returns an n-by-1 vector of cumulative stake.
% See also: blackjack.
% S=0; %starting money
[deck,count]=create_deck(deck_num);
for i=1:n
    S(i+1)=S(i)+blackjack_hand(deck,count,deck_num);
end
% old code
%    S = cumsum(arrayfun(@blackjack_hand,zeros(n,1)));

end

% ------------------------
function [deck,count] =create_deck(deck_num)
for i=1:deck_num
    deck(i,:)=[1 2 3 4 5 6 7 8 9 10 11 12 13];
end
count=0;
end

function s = blackjack_hand(deck,count,deck_num)
%BLACKJACK_HAND  Play one hand of blackjack.
%   s = blackjack_hand returns payoff from one hand.
if sum(deck)==0
    create_deck(deck_num)
end
true_count=count/deck_num;
if true_count>=1 && true_count<2
    bet=15;
elseif true_count>=2 && true_count<3
    bet=30;
elseif true_count>=3
    bet=50;
else
    bet = 10;
end

bet1 = bet;
[P,deck,count] = deal(deck,count);         % Player's hand
[D,deck,count] = deal(deck,count);         % Dealer's hand
[P_2nd,deck,count]=deal(deck,count);
[D_2nd,deck,count]=deal(deck,count);
P = [P P_2nd];
D = [D -D_2nd];    % Hide dealer's hole card

% Split pairs
split = (P(1) == P(2));
%    if split
%       split = pair(value(P(1)),value(D(1)));
%    end
if split
    P2 = P(2);
    [P_2nd,deck,count]=deal(deck,count);
    P = [P(1) P_2nd];
    bet2 = bet1;
end

% Play player's hand(s)
[P,bet1] = playhand('',P,D,bet1,deck,count);
if split
    [P_2nd,deck,count]=deal(deck,count);
    P2 = [P2 P_2nd];
    [P2,bet2] = playhand('',P2,D,bet2,deck,count);
end

% Play dealer's hand
D(2) = -D(2);     % Reveal dealer's hole card
while sum(D) <= 16
    [D_3rd,deck,count]=deal(deck,count);
    D = [D D_3rd];
end

% Payoff
s = payoff(P,D,split,bet1);
if split
    s = s + payoff(P2,D,split,bet2);
end
end

% ------------------------


function [c,deck,count] = deal(deck,count)
% Simulate continuous shuffling machine with infinite deck.
% c = deal returns a random integer between 1 and 13.
c = randi([1,13],1,1);
[idx,idy]=find(deck==c,1);
while isempty(idx)==1
    c = randi([1,13],1,1);
    [idx,idy]=find(deck==c,1);
end
if c<=6 && c>1
    count=count+1;
elseif c>=7 && c<=9
    count=count;
elseif c>=10 | c==1
    count=count-1;
end
deck(idx,idy)=0;

% old code
% for i=1:deck_num
%     deak(i,:)=[1 2 3 4 5 6 7 8 9 10 11 12 13];
% end
%    c = ceil(13*rand);
end

% ------------------------

function v = valuehard(X)
% Evaluate hand
X = min(X,10);
v = sum(X);
end

% ------------------------

function v = value(X)
% Evaluate hand
X = min(X,10);
v = sum(X);
% Promote soft ace
if any(X==1) & v<=11
    v = v + 10;
end
end

% ------------------------

function [P,bet] = playhand(hand,P,D,bet,deck,count)
% Play player's hand

while value(P) < 21
    % 0 = stand
    % 1 = hit
    % 2 = double down
    if any(P==1) & valuehard(P)<=10
        strat = soft(value(P)-11,value(D(1)));
    else
        strat = hard(value(P),value(D(1)));
    end
    if length(P) > 2 & strat == 2
        strat = 1;
    end
    switch strat
        case 0
            break
        case 1
            [P_2nd,deck,count]=deal(deck,count);
            P = [P P_2nd];
        case 2
            % Double down.
            % Double bet and get one more card
            bet = 2*bet;
            [P_2nd,deck,count]=deal(deck,count);
            P = [P P_2nd];
            break
        otherwise
            break
    end
end
end

% ------------------------

function s = payoff(P,D,split,bet)
% Payoff
fs = 20;
valP = value(P);
valD = value(D);
if valP == 21 & length(P) == 2 & ...
        ~(valD == 21 & length(D) == 2) & ~split
    s = (6/5)*bet;
elseif valP > 21
    s = -bet;
elseif valD > 21
    s = bet;
    str = ['WIN: +' int2str(s)];
elseif valD > valP
    s = -bet;
elseif valD < valP
    s = bet;
else
    s = 0;
end
end

% ------------------------

function strat = hard(p,d)
% Strategy for hands without aces.
% strategy = hard(player's_total,dealer's_upcard)

% 0 = stand
% 1 = hit
% 2 = double down

n = NaN; % Not possible
% Dealer shows:
%      2 3 4 5 6 7 8 9 T A
HARD = [ ...
    1   n n n n n n n n n n
    2   1 1 1 1 1 1 1 1 1 1
    3   1 1 1 1 1 1 1 1 1 1
    4   1 1 1 1 1 1 1 1 1 1
    5   1 1 1 1 1 1 1 1 1 1
    6   1 1 1 1 1 1 1 1 1 1
    7   1 1 1 1 1 1 1 1 1 1
    8   1 1 1 1 1 1 1 1 1 1
    9   2 2 2 2 2 1 1 1 1 1
    10   2 2 2 2 2 2 2 2 1 1
    11   2 2 2 2 2 2 2 2 2 2
    12   1 1 0 0 0 1 1 1 1 1
    13   0 0 0 0 0 1 1 1 1 1
    14   0 0 0 0 0 1 1 1 1 1
    15   0 0 0 0 0 1 1 1 1 1
    16   0 0 0 0 0 1 1 1 1 1
    17   0 0 0 0 0 0 0 0 0 0
    18   0 0 0 0 0 0 0 0 0 0
    19   0 0 0 0 0 0 0 0 0 0
    20   0 0 0 0 0 0 0 0 0 0];
strat = HARD(p,d);
end

% ------------------------

function strat = soft(p,d)
% Strategy array for hands with aces.
% strategy = soft(player's_total,dealer's_upcard)

% 0 = stand
% 1 = hit
% 2 = double down

n = NaN; % Not possible
% Dealer shows:
%      2 3 4 5 6 7 8 9 T A
SOFT = [ ...
    1   n n n n n n n n n n
    2   1 1 2 2 2 1 1 1 1 1
    3   1 1 2 2 2 1 1 1 1 1
    4   1 1 2 2 2 1 1 1 1 1
    5   1 1 2 2 2 1 1 1 1 1
    6   2 2 2 2 2 1 1 1 1 1
    7   0 2 2 2 2 0 0 1 1 0
    8   0 0 0 0 0 0 0 0 0 0
    9   0 0 0 0 0 0 0 0 0 0];
strat = SOFT(p,d);
end

% ------------------------

function strat = pair(p,d)
% Strategy for splitting pairs
% strategy = pair(paired_card,dealer's_upcard)

% 0 = keep pair
% 1 = split pair

n = NaN; % Not possible
% Dealer shows:
%      2 3 4 5 6 7 8 9 T A
PAIR = [ ...
    1   n n n n n n n n n n
    2   1 1 1 1 1 1 0 0 0 0
    3   1 1 1 1 1 1 0 0 0 0
    4   0 0 0 1 0 0 0 0 0 0
    5   0 0 0 0 0 0 0 0 0 0
    6   1 1 1 1 1 1 0 0 0 0
    7   1 1 1 1 1 1 1 0 0 0
    8   1 1 1 1 1 1 1 1 1 1
    9   1 1 1 1 1 0 1 1 0 0
    10   0 0 0 0 0 0 0 0 0 0
    11   1 1 1 1 1 1 1 1 1 1];
strat = PAIR(p,d);
end
