// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
// import ajax from "web/static/js/lib/ajax_setup";
// import zone from "web/static/js/zone";
// import state from "web/static/js/state";
// import order from "web/static/js/order";
// import order_show from "web/static/js/order_show";
// import payment from "web/static/js/payment";
// import cart_creator from "web/static/js/cart_creator";
// import Redux from "redux";
// import ReactDOM from "react-dom";
// import React from "react";
// import { MiniCart, CartNotification, ProductListing } from "./components";
// import configureStore from './store';
// import {Provider} from 'react-redux';
// import cartActions from './actions/cart';
// import cartNotificationActions from './actions/cart_notification';
// import productActions from './actions/product';

// ajax.setup();
// window.zone = zone;
// window.state = state;
// window.order = order;
// window.payment = payment;
// window.order_show = order_show;
// window.cart_creator = cart_creator;
// // Import local files
// //
// // Local files can be imported directly using relative
// // paths "./socket" or full ones "web/static/js/socket".

// // import socket from "./socket"

// // TODO: Re-write in ES6 style
// $(document).ready(function() {
//   $(document).on("click", "#add_option_value, #add_product_option_type, #add_category, #add_product_category", function(e) {
//     e.preventDefault();
//     let time = new Date().getTime();
//     let template = $(this).data("template");
//     var uniq_template = template.replace(/\[0\]/g, `[${time}]`);
//     uniq_template = uniq_template.replace(/_0_/g, `_${time}_`);
//     $(this).after(uniq_template);
//   });

//   $(document).on("click", "#delete_option_value, #delete_product_option_type, #delete_category, #delete_product_category", function(e) {
//     e.preventDefault();
//     $(this).parent().remove();
//   });
// });

// // React related code here //
// const store = configureStore();

// ReactDOM.render(<Provider store={store}>
//                   <div>
//                     <MiniCart/>
//                     <ProductListing/>
//                     <CartNotification/>
//                   </div>
//                 </Provider>,
//                 document.getElementById("cart"));

// window.fetchState = function() {
//   store.dispatch(cartActions.fetchCurrentCartSummary());
//   store.dispatch(productActions.getProductListing());
//   window.store = store;
// };

// $(document).ready(function(){
//   fetchState();
// });
/*
* refer: https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1 for an overview of implementation
*/

import viewToRender from "./views";

class Application {
  constructor() {
    const body = document.getElementsByTagName('body')[0];
    const viewName = body.getAttribute('data-js-view-name');
    const viewClass = viewToRender(viewName);

    this.view = new viewClass();
    window.addEventListener('DOMContentLoaded',
                            this.handleDOMContentLoaded.bind(this),
                            false);
    window.addEventListener('unload',
                            this.handleDocumentUnload.bind(this),
                            false);
  }

  handleDOMContentLoaded() {
    this.view.mount();
  }

  handleDocumentUnload() {
    this.view.unmount();
  }
}

new Application();
