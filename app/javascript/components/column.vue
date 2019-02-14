<template>
  <div class="list" >
    <h5>{{ column.title }}</h5>
    <button @click="removeColumn(column, index)" type="button" class="close" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <hr />
    <draggable v-model="column.cards" :options="{group: 'cards'}" class="draggArea" @change="cardMove">
      <div v-for="(card, index) in column.cards" class="card card-body mb-3">
        {{ card.title }}
        <button @click="removeCard(card)" class="btn btn-danger btn-sm">Remove card</button>
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
        card: {}
      }
    },
    methods: {
      cardMove: function(event) {
        const e = event.added || event.moved
        if (e == undefined) { return }

        const element = e.element

        const column_index = window.store.columns.findIndex((column) => {
          return column.cards.find((card) => {
            return card.id === element.id
          })
        })

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
            const index = window.store.columns.findIndex(item => item.id == this.column.id)
            window.store.columns[index].cards.push(data)
            this.message = undefined
          }
        })
      },

      removeCard: function(card) {
        Rails.ajax({
          url: `/cards/${card.id}`,
          type: "DELETE",
          dataType: "json",
          success: () => {
            this.card.$remove(card)
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
            console.log(index)
            window.store.columns.slice(column, index)
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
