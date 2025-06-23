import React from 'react';
import './SkeletonLoader.css';

interface SkeletonLoaderProps {
  type?: 'text' | 'avatar' | 'title' | 'card' | 'custom';
  lines?: number;
  width?: string;
  height?: string;
  className?: string;
  style?: React.CSSProperties;
}

const SkeletonLoader: React.FC<SkeletonLoaderProps> = ({
  type = 'text',
  lines = 1,
  width,
  height,
  className = '',
  style = {},
}) => {
  const baseStyle: React.CSSProperties = {
    width: width || '100%',
    height: height || (type === 'text' && lines === 1 ? '1em' : undefined),
    ...style,
  };

  if (type === 'card') {
    return (
      <div className={`skeleton-loader skeleton-card ${className}`} style={baseStyle}>
        <div className="skeleton-loader skeleton-title" style={{ width: '60%', marginBottom: '1rem' }} />
        <div className="skeleton-loader skeleton-text" style={{ width: '90%' }}/>
        <div className="skeleton-loader skeleton-text" style={{ width: '80%' }}/>
        <div className="skeleton-loader skeleton-text" style={{ width: '70%', marginTop: '1rem' }}/>
      </div>
    );
  }

  if (type === 'avatar') {
    return <div className={`skeleton-loader skeleton-avatar ${className}`} style={baseStyle} />;
  }

  if (type === 'title') {
    return <div className={`skeleton-loader skeleton-title ${className}`} style={{ ...baseStyle, height: height || '1.5em' }} />;
  }

  if (type === 'text') {
    return (
      <>
        {Array.from({ length: lines }).map((_, i) => (
          <div
            key={i}
            className={`skeleton-loader skeleton-text ${className}`}
            style={{
              ...baseStyle,
              height: height || '1em',
              width: i === lines - 1 && lines > 1 ? '70%' : baseStyle.width, // Shorter last line
              marginTop: i > 0 ? '0.5em' : undefined
            }}
          />
        ))}
      </>
    );
  }

  return <div className={`skeleton-loader ${className}`} style={baseStyle} />;
};

export default SkeletonLoader;
