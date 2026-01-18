<template>
  <span>Ordbok</span>
  <div>
    <span>Steg 1: Välj i antal bokstäver</span>
    <div>
      <form>
        <select v-model="lengthSelected">
          <option v-for="option in lengthOptions" :key=option :value="option">{{option}}</option>
        </select>
        <button type="button" @click="clickLength">Nästa</button>
      </form>
    </div>
    <div v-if=length>
      <span>Steg 2: Fyll i kända bokstäver</span>
      <div>
      <form ref="charForm">
        <input v-for="i in length" :key=i type="text" size="2" maxlength="1" onfocus="this.value=''" @focus="onCharFocus($event,i-1)" @keyup="addChar($event,i-1)" />
        <button type="button" @click="clearCharForm">Rensa</button>
      </form>
      </div>
      <span>{{ matches.length }} träffar</span>
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

export default {
  name: 'App',
  components: {
  },
  setup() {
    const data = [
      "accessit",
      "accessnät/ABDY",
      "accessoar/AHDYX",
      "accessorisk/OY",
      "accesstid/AHDYv",
      "accidens/HDX",
      "accidentell/OY",
      "accis/HDYXU",
      "accompli",
      "accpump/ADGv",
      "acetaldehyd/AHDYX",
      "acetat/ABHDYX",
      "acetatjon/AHD",
      "aceton/ABYX",
      "acetyl/AX",
      "acetylen/ABDYXU",
      "acetylenflaska/EAGY",
      "acetylengas/HDX",
      "acetylentub/AHDY",
      "acetylera/NAPmDj",
      "acetylering/ADYv",
      "acetylsalicylsyra/EAGY",
      "aciditet/AD",
      "ack",
      "Acke/A",
      "Acketoft/A",
      "ackja/EAG",
      "ackjefärd/AHDY",
      "acklamation/AHDYvf",
      "acklamationsval/ABDY",
      "acklimatisera/NAPmDY",
      "acklimatisering/ADGYvf",
      "ackommodation/AHDYv",
      "ackommodationsväxel/EAIY",
      "ackommodera/NAPmDj",
      "ackompanjatris/HDY",
      "ackompanjatör/AHDY",
      "ackompanjemang/ABDYvf",
      "ackompanjemangs-",
      "ackompanjemangsinstrument/ABDY",
      "ackompanjera/NAPmBY",
      "ackord/TABDYsvUf",
      "ackord-",
      "ackordeon/ABDY",
      "ackordera/NMAmDj",
      "ackordering/ADGYv",
      "ackordföljd/AHDY"
    ]
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
      // a-z (65-90), and å (219), ä (222) and ö (59)
      if ((e.keyCode >=65 && e.keyCode <= 90) || e.keyCode == 219 || e.keyCode == 222 || e.keyCode == 59) {
        chars[pos] = e.key
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
        if (chars[key] != value) return false
      }
      return true
    }
    const matches = ref([])
    onBeforeMount(() => {
      var tmpOptions = []
      for (var i = 0; i < data.length; i++) {
        const word = data[i].split("/",1)[0]
        tmpOptions.push(word.length)
      }
      lengthOptions.value = [...new Set(tmpOptions.sort(function(a, b) {return a - b}))]
      lengthSelected.value = lengthOptions.value[0]
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
