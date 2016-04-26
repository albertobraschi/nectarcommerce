import React from "react";
import cartActions from '../js/actions/cart';

class CartSummary extends React.Component {
  render() {
    return (<div className="cart">{this.cartMessage()}</div>);
  }

  cartMessage() {
    if (this.props.items_in_cart == 0) {
      return "Cart Empty";
    } else if (this.props.items_in_cart == 1) {
      return `${this.props.items_in_cart} item in cart`;
    } else {
      return `${this.props.items_in_cart} items in cart`;
    }
  }
}

CartSummary.propTypes = {
  items_in_cart: function(props, propName, componentName) {
    if (props[propName] < 0) {
      return new Error(`Invalid prop ${propName} supplied to ${componentName}, should be >= 0`);
    }
    return null;
  }
};

export default class MiniCart extends React.Component {
  constructor(props) {
    super(props);
    this.state = this.props.store.getState().mini_cart;
    this.updateMe = this.updateMe.bind(this);
  }

  componentWillMount() {
    let c = cartActions;
    this.props.store.subscribe(this.updateMe);
    this.props.store.dispatch(cartActions.fetchCurrentCartSummary());
  }

  updateMe(action, state) {
    this.setState(this.props.store.getState().mini_cart);
  }

  render() {
    return (<div className="btn btn-primary">
            <CartSummary items_in_cart={this.state.cart_summary.items_in_cart}/>
            </div>);
  }
}
