import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ReputationSystemModule", (m) => {
  const reputationSystem = m.contract("ReputationSystem");
  
  return { reputationSystem };
});