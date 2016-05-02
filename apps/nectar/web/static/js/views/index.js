import BaseView from "./base_view";
import ProductView from "./products";

// add all the views here.
const views = {ProductView};

export default function viewToRender(view) {
  let viewLookUp   = view.split(".");
  const actionName = viewLookUp.pop();
  const viewName   = viewLookUp.join(".");
  let actionLookup = views[viewName];

  if (actionLookup) {
    return actionLookup(actionName);
  } else {
    return BaseView;
  }
}
