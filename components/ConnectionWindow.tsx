// ConnectionWindow.tsx
import { useAccount } from 'wagmi';

export function ConnectionWindow() {
  const { address, isConnected, isConnecting, isDisconnected } = useAccount();

  return (
    <div>
		<h2>Connection Status</h2>
		<div>
			{isConnecting && <p>Please click Connect in your wallet...</p>}
			{isConnected && <p>{"Address: " + address}</p>}
			{isDisconnected && <p>Please connect your wallet to use this app.</p>}		</div>	
		</div>
  );
}