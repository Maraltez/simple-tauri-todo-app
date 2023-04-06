<script lang="ts">
import {defineComponent} from "vue";
import {message} from "@tauri-apps/api/dialog";
import {BaseDirectory, writeTextFile} from "@tauri-apps/api/fs";
import {appConfigDir, appDataDir, appLocalDataDir} from "@tauri-apps/api/path";

export default defineComponent({
  mounted() {
    appDataDir().then(path => console.log(path))
    appConfigDir().then(path => console.log(path))
    appLocalDataDir().then(path => console.log(path))

    writeTextFile({path: 'app.todo', contents: '1. make this app\n2. use this app'}, {dir: BaseDirectory.AppLocalData})
  }
})


</script>

<template>
  <header>
  </header>

  <main>

  </main>
</template>

<style scoped>

</style>
