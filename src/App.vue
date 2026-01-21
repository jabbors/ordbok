<template>
  <h3>Ordbok</h3>
  <div>
    <p><b>Steg 1:</b> Välj antal bokstäver</p>
    <div>
      <form>
        <select v-model="lengthSelected">
          <option v-for="option in lengthOptions" :key=option :value="option">{{option}}</option>
        </select>
        <button type="button" @click="clickLength">Nästa</button>
      </form>
    </div>
    <div v-if=length>
      <p><b>Steg 2:</b> Fyll i kända bokstäver</p>
      <div>
      <form ref="charForm">
        <input v-for="i in length" :key=i type="text" size="2" maxlength="1" onfocus="this.value=''" @focus="onCharFocus($event,i-1)" @keyup="addChar($event,i-1)" />
        <button type="button" @click="clearCharForm">Rensa</button>
      </form>
      </div>
      <p><b>{{ matches.length }} träffar</b></p>
      <div>
        <ul>
          <li v-for="match in matches" :key="match">{{ match }}</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onBeforeMount } from 'vue';
require('./assets/normalize.css')
require('./assets/skeleton.css')

export default {
  name: 'App',
  components: {
  },
  setup() {
    var data = []
    const length = ref(null)
    const lengthOptions = ref([])
    const lengthSelected = ref(null)
    const clickLength = () => {
      length.value = lengthSelected.value
      if (charForm.value != null) {
        charForm.value.reset()
      }
      chars = {}
      matches.value = []
      matchWords()
    }
    var chars = {}
    const charForm = ref(null)
    const addChar = (e,pos) => {
      // a-z (65-90), and å (219), ä (222) and ö (59) or backspace (8)
      if ((e.keyCode >=65 && e.keyCode <= 90) || e.keyCode == 219 || e.keyCode == 222 || e.keyCode == 59 || e.keyCode == 8) {
        if (e.keyCode == 8) {
          delete(chars[pos])
        } else {
          chars[pos] = e.key
        }
        matchWords()
      }
    }
    const onCharFocus = (e,pos) => {
      delete(chars[pos])
      matchWords()
    }
    const clearCharForm = () => {
      if (charForm.value != null) {
        charForm.value.reset()
      }
      chars = {}
      matches.value = []
      matchWords()
    }
    const matchWords = () => {
      matches.value = []
      if (Object.keys(chars).length > 0) {
        for (var i = 0; i < data.length; i++) {
          const word = data[i].split("/",1)[0]
          if (word.length == length.value) {
            if (matchWord(word, chars)) matches.value.push(word)
          }
        }
      }
    }
    const matchWord = (word, knownChars) => {
      const chars = word.split("")
      for (const [key, value] of Object.entries(knownChars)) {
        if (chars[key].toLowerCase() != value.toLowerCase()) return false
      }
      return true
    }
    const matches = ref([])
    onBeforeMount(() => {
      async function initializeData() {
        const url = "https://raw.githubusercontent.com/jabbors/ordbok/refs/heads/master/docs/sv_SE.dic";
        try {
          const response = await fetch(url)
          if (!response.ok) {
            throw new Error(`Response status: ${response.status}`)
          }
          var tmpData = []
          var tmpOptions = []
          const text = await response.text()
          const words = text.split(/\r?\n/)
          for (var i = 0; i < words.length; i++) {
            const word = words[i].split("/",1)[0]
            if (word.length < 2) {
              continue
            }
            tmpData.push(word)
            tmpOptions.push(word.length)
          }
          data = [...new Set(tmpData)]
          lengthOptions.value = [...new Set(tmpOptions.sort(function(a, b) {return a - b}))]
          lengthSelected.value = lengthOptions.value[0]
        } catch (error) {
          console.error(error.message);
        }
      }
      initializeData()
    })

    return { length, lengthOptions, lengthSelected, clickLength, charForm, addChar, onCharFocus, clearCharForm, matches}
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
