import ReactDOM       from "react-dom";
import { Provider }   from "react-redux";

import { MiniCart }   from "../components";
import configureStore from "../store";
import cartActions    from "../actions/cart";

export default class BaseView {
  mount() {
    this.store = configureStore();
    console.log("common action for application");
  }

  unmount() {
    console.log("common action for application");
  }
}
