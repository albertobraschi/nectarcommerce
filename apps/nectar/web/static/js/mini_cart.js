import React from "react";

class MiniCartDetail extends React.Component {
  render() {
    return (<div className="cart">{this.cartMessage()}</div>);
  }

  cartMessage() {
    if (this.props.itemsInCart == 0) {
      return "Cart Empty";
    } else if (this.props.itemsInCart == 1) {
      return `${this.props.itemsInCart} item in cart`;
    } else {
      return `${this.props.itemsInCart} items in cart`;
    }
  }
}

MiniCartDetail.propTypes = {
  itemsInCart: function(props, propName, componentName) {
    console.log(props);
    console.log(propName);
    console.log(componentName);
    if (props[propName] < 0) {
      return new Error(`Invalid prop ${propName} supplied to ${componentName}, should be >= 0`);
    }
  }
};

export default class MiniCart extends React.Component {
  constructor(props) {
    super(props);
    this.state = {itemsInCart: 0};
  }

  componentWillMount() {
    console.log("Fetch cart data before mounting component to update state");
    console.log("current state: ", this.state);
  }

  render() {
    return (<div className="btn btn-primary">
            <MiniCartDetail itemsInCart={this.state.itemsInCart}/>
            </div>);
  }
}
