<template>
  <div class="list">
    <div class="row">
      <div class="col">
      <h5>{{ column.title }}</h5>
      </div>
      <div class="col-auto">
      <button @click="removeColumn(column)" class="btn btn-sm btn-secondary pull-right" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      </div>
    </div>
    <hr />
    <draggable v-model="column.cards" :options="{group: 'cards'}" class="draggArea" @change="cardMove">
      <div v-for="(card, index) in column.cards" class="card card-body mb-3">
        <div v-if="editing">
          <div class="card card-body">
            <textarea v-model="card.title" class="form-control"></textarea>
            <button @click="saveCard(card)" class="btn btn-primary btn-sm">Save</button>
            <hr/>
            <button @click="cancelEditCard(card)" class="btn btn-danger btn-sm">Cancel</button>
          </div>
        </div>

        <div v-else>
          <div class="card card-body">
            {{card.title}}
            <button @click="removeCard(card)" class="btn btn-danger btn-sm">Remove card</button>
            <hr/>
            <button @click="editCard(card)" class="btn btn-primary btn-sm">Edit card</button>
          </div>
        </div>
      </div>
    </draggable>

    <div class="card card-body">
      <textarea v-model="message" class="form-control"></textarea>
      <hr/>
      <button v-on:click="addCard(column.id)" class="btn btn-primary">Add</button>
    </div>
  </div>
</template>

<script>
  import draggable from 'vuedraggable'

  export default {
    props: ["column"],
    components: {draggable},

    data: function() {
      return {
        message: "",
        card: {},
        editing: false
      }
    },
    methods: {

      cancelEditCard: function(card) {
        Object.assign(card, this._beforeEditingCache);
        this.editing = false
      },

      editCard: function(card) {
        this._beforeEditingCache = Object.assign({}, card);
        this.editing = true

      },

      cardMove: function(event) {
        const e = event.added || event.moved
        if (e == undefined) { return }

        const element = e.element

        const column_index = window.store.columns.findIndex((column) => {
          return column.cards.find((card) => {
            return card.id === element.id
          })
        });

        let data = new FormData
        data.append("card[column_id]", window.store.columns[column_index].id)
        data.append("card[position]", e.newIndex + 1)

        Rails.ajax({
          url: `/cards/${element.id}`,
          type: "PATCH",
          data: data,
          dataType: "json"
        })
      },

      addCard: function(column_id) {
        let data = new FormData
        data.append("card[column_id]", column_id)
        data.append("card[title]", this.message)

        Rails.ajax({
          url: "/columns/" + column_id + "/cards",
          type: "POST",
          data: data,
          dataType: "json",
          success: (data) => {
            const index = window.store.columns.findIndex(item => item.id == column_id)
            window.store.columns[index].cards = window.store.columns[index].cards || []
            window.store.columns[index].cards.push(data)
            this.message = undefined
          }
        })
      },

      saveCard: function(card) {
        let data = new FormData
        data.append("card[title]", card.title);

        Rails.ajax({
          url: `/cards/${card.id}`,
          type: "PATCH",
          data: data,
          dataType: "json",
          success: () => {
            const column_index = window.store.columns.findIndex(item => item.id == this.column.id)
            const card_index = window.store.columns[column_index].cards.findIndex(item => item.id == card.id)
            window.store.columns[column_index].cards[card_index].title = card.title
            this.editing = false
          }
        })
      },

      removeCard: function(card) {
        Rails.ajax({
          url: `/cards/${card.id}`,
          type: "DELETE",
          dataType: "json",
          success: () => {
            const column_index = window.store.columns.findIndex(item => item.id == this.column.id)
            const card_index = window.store.columns[column_index].cards.findIndex(item => item.id == card.id)
            window.store.columns[column_index].cards.splice(card_index, 1)
          }
        })
      },

      removeColumn: function(column) {
        Rails.ajax({
          url: `/columns/${column.id}`,
          type: "DELETE",
          dataType: "json",
          success: () => {
            const index = window.store.columns.findIndex((item) => item.id === this.column.id)
            window.store.columns.splice(index, 1)
          }
        })
      }
    }
  }
</script>

<style scoped>
  .draggArea {
    min-height: 15px;
  }

  .list {
    background: aliceblue;
    border-radius: 3px;
    display: inline-block;
    margin-right: 20px;
    padding: 10px;
    vertical-align: top;
    width: 270px;
  }
</style>
