<template>
  <div class="test">
    <draggable :options="{group: 'card'}" class="draggArea" @change="cardMove">
      <div class="card card-body mb-3">
        {{ title }}
        <button @click="removeCard(card)" class="btn btn-danger btn-sm">Remove</button>
      </div>
    </draggable>
  </div>
</template>

<script>
  import draggable from 'vuedraggable'

  export default {
    props: ['card'],
    components: { draggable },
    data: function() {
      return {
        editing: false,
        title: this.card.title,
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
            window.store.columns.splice( window.store.events.indexOf(card), 1);
          }

        })
      }
    }
      // closeModal: function(event) {
      //   if (event.target.classList.contains("modal")) { this.editing = false }
      // },
      //
      // saveCard: function() {
      //   var data = new FormData
      //   data.append("card[name]", this.name)
      //
      //   Rails.ajax({
      //     beforeSend: () => true,
      //     url: `/cards/${this.card.id}`,
      //     type: "PATCH",
      //     data: data,
      //     dataType: "json",
      //     success: (data) => {
      //       this.editing = false
      //     }
      //   })
      // },
  }
</script>

<style scoped>
</style>
