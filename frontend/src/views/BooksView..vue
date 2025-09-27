<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "@/services/api";

interface Book {
  id: number;
  title: string;
  isbn: string;
  stock: number;
}

interface Pagination {
  page: number;
  prev: number | null;
  next: number | null;
  last: number;
  count: number;
  from: number;
  to: number;
}

const books = ref<Book[]>([]);
const pagination = ref<Pagination | null>(null);
const currentPage = ref(1);

const title = ref("");
const isbn = ref("");
const stock = ref<number | null>(null);

// 🔍 Search state
const search = ref("");

const fetchBooks = async (page = 1, query = "") => {
  const res = await api.get("/books", {
    params: { page, q: query || undefined },
  });
  books.value = res.data.data;
  pagination.value = res.data.pagination;
  currentPage.value = page;
};

const addBook = async () => {
  if (!title.value || !isbn.value || stock.value === null) return;
  await api.post("/books", {
    title: title.value,
    isbn: isbn.value,
    stock: stock.value,
  });
  title.value = "";
  isbn.value = "";
  stock.value = null;
  fetchBooks(currentPage.value, search.value);
};

const handleSearch = () => {
  fetchBooks(1, search.value);
};

onMounted(() => fetchBooks(1));
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">📘 Books</h1>

    <!-- 🔍 Search Bar -->
    <div class="flex gap-2 mb-6">
      <input
        v-model="search"
        @keyup.enter="handleSearch"
        type="text"
        placeholder="Search by title or ISBN..."
        class="border rounded px-3 py-2 flex-1"
      />
      <button
        @click="handleSearch"
        class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
      >
        Search
      </button>
    </div>

    <!-- Add Book Form -->
    <form @submit.prevent="addBook" class="flex flex-wrap gap-3 mb-8">
      <input v-model="title" type="text" placeholder="Title"
        class="border rounded px-3 py-2 flex-1" />
      <input v-model="isbn" type="text" placeholder="ISBN"
        class="border rounded px-3 py-2 flex-1" />
      <input v-model.number="stock" type="number" placeholder="Stock"
        class="border rounded px-3 py-2 w-28" />
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
      >
        Add
      </button>
    </form>

    <!-- Books Table -->
    <div class="overflow-x-auto bg-white shadow rounded-lg">
      <table class="min-w-full text-sm text-left">
        <thead class="bg-gray-100 text-gray-700 uppercase text-xs">
          <tr>
            <th class="px-4 py-2">ID</th>
            <th class="px-4 py-2">Title</th>
            <th class="px-4 py-2">ISBN</th>
            <th class="px-4 py-2">Stock</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="b in books" :key="b.id" class="border-t hover:bg-gray-50">
            <td class="px-4 py-2">{{ b.id }}</td>
            <td class="px-4 py-2">{{ b.title }}</td>
            <td class="px-4 py-2">{{ b.isbn }}</td>
            <td class="px-4 py-2">{{ b.stock }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="pagination" class="flex justify-between items-center mt-6">
      <button
        :disabled="!pagination.prev"
        @click="fetchBooks(pagination.prev || 1, search)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Previous
      </button>

      <span class="text-sm text-gray-600">
        Page {{ pagination.page }} of {{ pagination.last }}
        (showing {{ pagination.from }}–{{ pagination.to }} of {{ pagination.count }})
      </span>

      <button
        :disabled="!pagination.next"
        @click="fetchBooks(pagination.next || pagination.last, search)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Next
      </button>
    </div>
  </div>
</template>