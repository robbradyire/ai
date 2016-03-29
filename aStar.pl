% arc(RootNode, Neighbor, Seed, Cost)
arc(N, M, Seed, Cost) :- M is N*Seed, Cost=1.
arc(N, M, Seed, Cost) :- M is N*Seed + 1, Cost=2.

% goal(Node, TargetNode)
goal(N,Target) :- 0 is N mod Target.

% h(Node, HeuristicValue, TargetNode)
h(N, Hvalue, Target) :- goal(N, Target), !, Hvalue is 0;
    Hvalue is 1/N.

% less(NodeCostPair1, NodeCostPair2, TargetNode)
less([Node1, Cost1], [Node2, Cost2], Target) :-
    h(Node1, Hvalue1, Target), h(Node2, Hvalue2, Target),
    F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
    F1 =< F2.

% makeNeighborNodes(RootNode, NodeCostPairList, TraversalCost, NeighborNodes)
makeNeighborNodes(_, [], _, []).
makeNeighborNodes([_,NCost], [Head|Tail], Cost, [[Head, SumCost]|FNodes]) :-
    SumCost is NCost+Cost,
    makeNeighborNodes([_,NCost], Tail, Cost, FNodes).

% getAdjacentNodes(RootNode, Seed, AdjacentNodes)
getAdjacentNodes([R,RCost], Seed, ANodes) :-
    setof(X, arc(R, X, Seed, 1), Nodes1),
    setof(Y, arc(R, Y, Seed, 2), Nodes2),
    makeNeighborNodes([R,RCost], Nodes1, 1, FNodes1),
    makeNeighborNodes([R,RCost], Nodes2, 2, FNodes2),
    append(FNodes1, FNodes2, ANodes).

% addToFrontier(Node, OldFrontier, NewFrontier, TargetNode)
addToFrontier(Node, [], [Node], _).
addToFrontier(Node, [Lowest | Tail], Fnew, Target) :-
    less(Node, Lowest, Target), append([Node, Lowest], Tail, Fnew);
    append([Lowest], FRest, Fnew), addToFrontier(Node, Tail, FRest, Target).

% addNodesToFrontier(NodeList, OldFrontier, NewFrontier, TargetNode)
addNodesToFrontier([], Fr, Fr, _).
addNodesToFrontier([H|T], Fr, NewFr, Target) :- 
    addToFrontier(H, Fr, TmpFr, Target), addNodesToFrontier(T, TmpFr, NewFr, Target).

% search(Frontier, Seed, Target, Result)
search([[Node, _]|_], _, Target, Node) :- goal(Node, Target).
search([Node | FRest], Seed, Target, Found) :-
    getAdjacentNodes(Node, Seed, ANodes),
    addNodesToFrontier(ANodes, FRest, FNew, Target),
    search(FNew, Seed, Target, Found).

% aStar(StartNodeNumber, Seed, Target, Result)
aStar(Start, Seed, Target, Found) :-
    search([[Start, 0]], Seed, Target, Found).
