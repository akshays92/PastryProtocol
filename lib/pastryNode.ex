defmodule Pastry.PastryNode do
    use GenServer

    #Genserver DEF functions    
    def start_link(nodeID) do
        GenServer.start_link(__MODULE__,%{nodeID: nodeID},name: String.to_atom(nodeID))
    end

    def init(init_data) do
        {:ok,init_data} 
    end
    
    #Client callable functions

    #populating leaf set
    def populateLeafSet(pid, smallerLeafset, largerLeafSet) do
        IO.puts "populate called"
        GenServer.cast(String.to_atom(pid), {:populateLeafSet, smallerLeafset,largerLeafSet})
        #GenServer.cast()
    end

    #server side functions
    def handle_cast({:populateLeafSet,smallerLeafset,largerLeafSet }, state) do
        state=Map.put(state,:smallerLeafset,smallerLeafset)
        state=Map.put(state,:largerLeafSet,largerLeafSet)
        #IO.puts "smallerLeafSet for : "<> Map.get(state,:nodeID)
        #IO.inspect Map.get(state,:smallerLeafset)
        #IO.puts "largerLeafSet for : "<> Map.get(state,:nodeID)
        #IO.inspect Map.get(state,:largerLeafSet)
        {:noreply, state}
    end
end