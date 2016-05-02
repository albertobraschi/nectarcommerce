import BaseView from "../base_view";


export default class BaseProductView extends BaseView {
  mount() {
    super.mount();
    console.log("common action for products view");
  }

  unmount() {
    super.unmount();
    console.log("common action for products view");
  }
}
