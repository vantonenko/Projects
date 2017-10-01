function StateNode(state, parentStateNode, depth) {
    this.state = state;
    this.parentStateNode = parentStateNode;
    this.depth = parentStateNode ? parentStateNode.depth + 1 : 0;
}