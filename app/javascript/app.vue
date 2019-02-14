<template>
  <div class="container">
    <div class="board">
      <column v-for="(column, index) in columns" :column="column"></column>
      <div class="list">
        Create new card
        <textarea v-model="message" class="form-control"></textarea>
        <button v-on:click="addColumn()" class="btn btn-primary">Add new column</button>
      </div>
    </div>
  </div>
</template>

<script>
  import column from 'components/column'

  export default {
    components: { column },

    props: ["original_columns"],

    data: function () {
      return {
        active: false,
        message: "",
        columns: this.original_columns,
      }
    },
    methods: {
      addColumn: function() {
        let data = new FormData
        data.append("column[title]", this.message)

        Rails.ajax({
          url: `/boards/${window.store.board.uid}/columns`,
          type: "POST",
          data: data,
          dataType: "json",
          success: (data) => {
            window.store.columns.push(data)
            this.message = ''
          }
        })

      }

    }
  }
</script>

<style scoped>
  .board {
    overflow-x: auto;
    white-space: nowrap;
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
