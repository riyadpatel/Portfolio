import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class CPUSimulator {

    // Define the available instructions for this simulator
    public enum InstructionType { LOAD, STORE, ADD, SUB, MUL, DIV }
    public static class Instruction {
        InstructionType type;
        int operand1;
        int operand2;

        public Instruction(InstructionType type, int operand1, int operand2) {
            this.type = type;
            this.operand1 = operand1;
            this.operand2 = operand2;
        }
    }

    // LRU Cache Implementation using LinkedHashMap
    public static class LRUCache<K, V> extends LinkedHashMap<K, V> {
        private final int capacity;

        public LRUCache(int capacity) {
            super(capacity, 0.75f, true);
            this.capacity = capacity;
        }

        @Override
        protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
            return size() > capacity;
        }
    }

    private final LRUCache<Integer, Integer> cache;
    private final Map<Integer, Integer> memory;

    public CPUSimulator(int cacheSize) {
        this.cache = new LRUCache<>(cacheSize);
        this.memory = new HashMap<>();
    }

    // Execute a list of instructions
    public void execute(Instruction[] instructions) {
        for (Instruction instruction : instructions) {
            switch (instruction.type) {
                case LOAD:
                    load(instruction.operand1);
                    break;
                case STORE:
                    store(instruction.operand1, instruction.operand2);
                    break;
                case ADD:
                    add(instruction.operand1, instruction.operand2);
                    break;
                case SUB:
                    sub(instruction.operand1, instruction.operand2);
                    break;
                case MUL:
                    mul(instruction.operand1, instruction.operand2);
                    break;
                case DIV:
                    div(instruction.operand1, instruction.operand2);
                    break;
            }
        }
    }

    // Cache-aware LOAD instruction
    private int load(int address) {
        if (cache.containsKey(address)) {
            System.out.println("Cache hit for address: " + address);
            return cache.get(address);
        } else {
            System.out.println("Cache miss for address: " + address);
            int value = memory.getOrDefault(address, 0);
            cache.put(address, value);
            return value;
        }
    }

    // STORE instruction that writes to memory and cache
    private void store(int address, int value) {
        memory.put(address, value);
        cache.put(address, value);
        System.out.println("Stored value " + value + " at address: " + address);
    }

    // ADD instruction (adds two values and stores result in cache)
    private void add(int operand1, int operand2) {
        int result = load(operand1) + load(operand2);
        store(operand1, result);
        System.out.println("Added: " + result);
    }

    // SUB instruction
    private void sub(int operand1, int operand2) {
        int result = load(operand1) - load(operand2);
        store(operand1, result);
        System.out.println("Subtracted: " + result);
    }

    // MUL instruction
    private void mul(int operand1, int operand2) {
        int result = load(operand1) * load(operand2);
        store(operand1, result);
        System.out.println("Multiplied: " + result);
    }

    // DIV instruction with basic error handling
    private void div(int operand1, int operand2) {
        if (load(operand2) != 0) {
            int result = load(operand1) / load(operand2);
            store(operand1, result);
            System.out.println("Divided: " + result);
        } else {
            System.out.println("Error: Division by zero.");
        }
    }

    public static void main(String[] args) {
        // Initialize CPU simulator with cache size of 4
        CPUSimulator cpu = new CPUSimulator(4);

        // Sample instructions to execute
        Instruction[] instructions = {
            new Instruction(InstructionType.STORE, 1, 100),
            new Instruction(InstructionType.LOAD, 1, 0),
            new Instruction(InstructionType.ADD, 1, 2),
            new Instruction(InstructionType.SUB, 1, 2),
            new Instruction(InstructionType.MUL, 1, 2),
            new Instruction(InstructionType.DIV, 1, 2)
        };

        cpu.execute(instructions);
    }
}
