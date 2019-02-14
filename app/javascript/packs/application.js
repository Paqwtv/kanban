/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

window.store = {}

document.addEventListener("turbolinks:load", function() {
  var element = document.querySelector("#lists");

  window.store.columns = JSON.parse(element.dataset.columns);
  window.store.board = JSON.parse(element.dataset.board);

  if (element != undefined) {
    const app = new Vue({
      el: element,
      data: window.store,
      template: "<App :original_columns='columns' />",
      components: { App }
    })
  }

});

