import React from 'react';
import { OldButton } from '@patternfly/react-core';

export const TestComponent = () => {
  // TODO: Update OldButton later
  const myOldButton = 'something';
  const docs = "Check OldButton docs";

  return (
    <div>
      <OldButton variant="primary">Click me</OldButton>
      {/* OldButton is deprecated */}
    </div>
  );
};
