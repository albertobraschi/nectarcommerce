import BaseProductView from "./base_product_view";


export default class IndexView extends BaseProductView {
  mount() {
    super.unmount();
    console.log("actions for products index view");
  }

  unmount() {
    super.unmount();
    console.log("actions for products index view");
  }
}
